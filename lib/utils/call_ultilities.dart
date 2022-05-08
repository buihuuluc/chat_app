import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chat_app/models/call.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/resources/call_methods.dart';
import 'package:chat_app/screens/callscreens/call_screen.dart';
import 'package:chat_app/utils/utilities.dart';

class CallUltils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
