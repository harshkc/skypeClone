import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';

class UserCircle extends StatelessWidget {
  final String initials;

  UserCircle({this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: kSeparatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              initials ?? "NA",
              style: TextStyle(
                color: kLightBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
          ),
          kAlignedOnlineDot, //online dot Widget Aligned bottom right
        ],
      ),
    );
  }
}
