import 'package:chat_app/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/models/call.dart';
import 'package:chat_app/models/log.dart';
import 'package:chat_app/resources/call_methods.dart';
import 'package:chat_app/resources/local_db/repository/log_repository.dart';
import 'package:chat_app/screens/callscreens/call_screen.dart';
import 'package:chat_app/screens/callscreens/audio_call.dart';
import 'package:chat_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:chat_app/utils/permissions.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/call_background/a.jpeg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.call.callerName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: UniversalVariables.whiteColor.withOpacity(0.8)),
              ),
              SizedBox(height: 50),
              CachedImage(
                widget.call.callerPic,
                isRound: true,
                radius: 180,
              ),
              SizedBox(height: 50),
              Text(
                "Calling...",
                style: TextStyle(
                    fontSize: 25,
                    color: UniversalVariables.whiteColor.withOpacity(0.7)),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                        child: Icon(
                          Icons.video_call,
                          color: UniversalVariables.whiteColor,
                          size: 40.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor:
                            UniversalVariables.kPrimaryColor.withOpacity(0.5),
                        padding: const EdgeInsets.all(10.0),
                        onPressed: () async {
                          isCallMissed = false;
                          addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                          await Permissions
                                  .cameraAndMicrophonePermissionsGranted()
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CallScreen(call: widget.call),
                                  ),
                                )
                              : {};
                        }),
                    SizedBox(width: 10),
                    RawMaterialButton(
                      child: Icon(
                        Icons.call_end,
                        size: 40.0,
                        color: UniversalVariables.whiteColor,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.redAccent.withOpacity(0.7),
                      padding: const EdgeInsets.all(15.0),
                      onPressed: () async {
                        isCallMissed = false;
                        addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                        await callMethods.endCall(call: widget.call);
                      },
                    ),
                    SizedBox(width: 10),
                    RawMaterialButton(
                        child: Icon(
                          Icons.call,
                          color: UniversalVariables.whiteColor,
                          size: 40.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor:
                            UniversalVariables.kPrimaryColor.withOpacity(0.5),
                        padding: const EdgeInsets.all(10.0),
                        onPressed: () async {
                          isCallMissed = false;
                          addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                          await Permissions
                                  .cameraAndMicrophonePermissionsGranted()
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AudioScreen(call: widget.call),
                                  ),
                                )
                              : {};
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
