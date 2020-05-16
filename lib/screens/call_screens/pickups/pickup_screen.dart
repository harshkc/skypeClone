import 'package:skypeclone/models/call.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/resources/call_methods.dart';
import 'package:skypeclone/screens/call_screens/call_screen.dart';
import 'package:skypeclone/utils/constants.dart';
import 'package:skypeclone/utils/permissions.dart';
import 'package:skypeclone/widgets/cached_image.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  PickupScreen({this.call});
  final CallMethods callMethods = CallMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming call...",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.greenAccent,
              ),
            ),
            SizedBox(height: 50.0),
            CachedImage(
              call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 20.0),
            Text(
              call.callerName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 75.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.call_end,
                      color: Colors.redAccent,
                      size: 35.0,
                    ),
                  ),
                  onTap: () async => await callMethods.endCall(call: call),
                ),
                SizedBox(width: 45.0),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kLightBlueColor,
                    ),
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 35.0,
                    ),
                  ),
                  onTap: () async =>
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(call: call),
                              ),
                            )
                          : print("Give the permissions"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
