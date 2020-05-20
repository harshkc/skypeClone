import 'package:flutter/material.dart';
import 'package:skypeclone/screens/search_screen.dart';
import 'package:skypeclone/utils/constants.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
        color: kSeparatorColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "This is where all your contacts are listed",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 25.0),
            Text(
              "Search for your friends and family to start calling or chatting with them",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.2,
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 25.0),
            FlatButton(
              color: kLightBlueColor,
              child: Text(
                "START SEARCHING",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
