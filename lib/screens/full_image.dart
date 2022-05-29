import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:chat_app/utils/universal_variables.dart';

class FullImageScreen extends StatelessWidget {
  String photoUrl;
  FullImageScreen({Key key, this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: UniversalVariables.kPrimaryColor,
        title: Text(
          'Images Full Size',
          style: TextStyle(color: UniversalVariables.whiteColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: UniversalVariables.whiteColor,
        ),
        child: PhotoView(
          imageProvider: NetworkImage(photoUrl),
        ),
      ),
    );
  }
}
