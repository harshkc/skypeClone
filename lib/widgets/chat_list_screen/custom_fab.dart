import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skypeclone/utils/constants.dart';

class CustomFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kFabGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: GestureDetector(
        child: Icon(
          MdiIcons.pencilOutline,
          color: Colors.white,
          size: 30.0,
        ),
        onTap: () {},
      ),
      padding: EdgeInsets.all(11.5),
    );
  }
}
