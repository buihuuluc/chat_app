import 'package:avatar_view/avatar_view.dart';
import 'package:camera_deep_ar/camera_deep_ar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/configs/api_keys.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FillterScreenState createState() => _FillterScreenState();
}

class _FillterScreenState extends State<FilterScreen> {
  CameraDeepArController cameraDeepArController;
  int currentPage = 0;
  // final vp PageController(viewportFraction: .25);
  Effects currentEffects = Effects.none;
  Filters currentFilters = Filters.none;
  Masks currentMask = Masks.none;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraDeepAr(
              onCameraReady: (isReady) {
                setState(() {});
              },
              onImageCaptured: (path) {
                setState(() {});
              },
              onVideoRecorded: (path) {
                setState(() {});
              },
              androidLicenceKey: AR_KEY,
              iosLicenceKey: AR_KEY,
              cameraDeepArCallback: (c) async {
                cameraDeepArController = c;
                setState(() {});
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  pressed == false
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          child: Expanded(
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black38,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  CupertinoIcons.camera,
                                  size: 30,
                                ),
                                color: Colors.white54,
                                padding: EdgeInsets.all(15),
                                onPressed: () {
                                  if (null == cameraDeepArController) {
                                    return print('miss');
                                  }
                                  cameraDeepArController.snapPhoto();
                                  pressed = true;
                                }),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          child: Expanded(
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black38,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                color: Colors.green.withOpacity(0.5),
                                padding: EdgeInsets.all(15),
                                onPressed: () {
                                  Navigator.pop(context);
                                  pressed = false;
                                }),
                          ),
                        ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(8, (page) {
                        bool active = currentPage == page;
                        return GestureDetector(
                            onTap: () {
                              currentPage = page;
                              cameraDeepArController.changeMask(page);
                              setState(() {});
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: AvatarView(
                                radius: active ? 40 : 30,
                                borderColor: Colors.amberAccent,
                                borderWidth: 2,
                                isOnlyText: false,
                                avatarType: AvatarType.CIRCLE,
                                backgroundColor: Colors.red,
                                imagePath:
                                    "assets/icon/icon${page.toString()}.jpg",
                                placeHolder: Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                                errorWidget: Container(
                                  child: Icon(
                                    Icons.error,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ));
                      }),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
