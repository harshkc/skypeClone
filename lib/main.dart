import "package:flutter/material.dart";
import 'package:skypeclone/resources/firebase_repositry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skypeclone/screens/home.dart';
import 'package:skypeclone/screens/login.dart';
import 'package:skypeclone/screens/search_screen.dart';
import 'package:skypeclone/utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepositry _repositry = FirebaseRepositry();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Skype",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/search_screen": (context) => SearchScreen(),
      },
      theme: ThemeData(
        //brightness: Brightness.dark,
        scaffoldBackgroundColor: kBlackColor,
      ),
      home: FutureBuilder(
        future: _repositry.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (!snapshot.hasData) {
            return LoginScreen();
          } else {
            return HomeScreen();
          }
        },
      ),
    );
  }
}
