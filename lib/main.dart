import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/provider/user_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
