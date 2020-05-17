import 'package:flutter/material.dart';

///Values///
final double kLabelFontSize = 10;

///Values///

///colors///
final Color kBlueColor = Color(0xff2b9ed4);
final Color kBlackColor = Color(0xff19191b);
final Color kGreyColor = Color(0xff8f8f8f);
final Color kUserCircleBackground = Color(0xff2b2b33);
final Color kOnlineDotColor = Color(0xff46dc64);
final Color kLightBlueColor = Color(0xff0077d7);
final Color kSeparatorColor = Color(0xff272c35);

final Color kGradientColorStart = Color(0xff00b6f3);
final Color kGradientColorEnd = Color(0xff0184dc);

final Color kSenderColor = Color(0xff2b343b);
final Color kReceiverColor = Color(0xff1e2225);

final Gradient kFabGradient = LinearGradient(
    colors: [kGradientColorStart, kGradientColorEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);

///colors///

//           Widgets
final Widget kAlignedOnlineDot = Align(
  alignment: Alignment.bottomRight,
  child: Container(
    width: 12.0,
    height: 12.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: kBlackColor,
        width: 2,
      ),
      color: kOnlineDotColor,
    ),
  ),
);
