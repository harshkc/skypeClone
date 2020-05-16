import 'dart:math';
import 'package:flutter/material.dart';
import 'package:skypeclone/models/call.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/resources/call_methods.dart';
import 'package:skypeclone/screens/call_screens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId:
          "Ap${Random().nextInt(10)}%Ha${Random().nextInt(1000).toString()}@",
    );
    bool callMade = await callMethods.makeCall(call: call);

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CallScreen(call: call)),
      );
    }
  }
}
