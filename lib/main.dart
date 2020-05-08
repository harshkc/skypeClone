import "package:flutter/material.dart";
import 'package:skypeclone/resources/firebase_repositry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skypeclone/screens/home.dart';
import 'package:skypeclone/screens/login.dart';

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
