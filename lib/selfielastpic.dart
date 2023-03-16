import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelfieLastPic extends StatelessWidget {
  const SelfieLastPic({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Selfie")),
      body: Center(
        child: Image.network(imagePath),
      ),
    );
  }
}
