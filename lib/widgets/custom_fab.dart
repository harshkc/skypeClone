import 'package:flutter/material.dart';
import 'package:skypeclone/utils/constants.dart';

class CustomFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kFabGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25.0,
        ),
        onPressed: () {},
      ),
      padding: EdgeInsets.all(7.5),
    );
  }
}
