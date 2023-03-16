import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selfie/selfielastpic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = FirebaseFirestore.instance;
  bool isUploading = false;
  String? imagePath;
  int value = 0;
  String url ="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SelfieLastPic(imagePath: url)));

              },child: Text(

                  "show last pic"),
              )
                
            ),
          ),
          Text(isUploading ? "uploadin selfie" : ""),
          imagePath == null ? SizedBox() : Image.file(File(imagePath!)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: value == 1
                      ? () {
                          pickImage();
                        }
                      : null,
                  child: Text("Take Selfie")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              width: 300,
              child: OutlinedButton(
                  onPressed: () {
                    uploadImage();
                  },
                  child: Row(
                    children: [
                      Text(isUploading ? "Uploading image" : "Upload"),
                      isUploading ? CircularProgressIndicator():Icon(Icons.upload),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Future<void> read() async {
    var data = await firestore.collection("selfie").doc("capture").get();
    setState(() {
      value = data['capture_variable'];
      url =data['selfieUrl'];
    });
    print(value);
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imagePath = image?.path;
      print(imagePath);
    });
  }

  Future<void> uploadImage() async {
    late String downloadUrl;
    setState(() {
      isUploading = true;
    });
    FirebaseStorage.instance
        .ref()
        .child("images")
        .putFile(File(imagePath!))
        .then((snapshot) async {
      downloadUrl = await snapshot.ref.getDownloadURL();

      await firestore
          .collection("selfie")
          .doc("capture")
          .update({"selfieUrl": downloadUrl});
    });

    setState(() {
      isUploading = false;
    });

    try {} on FirebaseException catch (e) {
      print(e.message);
    }
    
  }
}
