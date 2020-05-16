import 'package:flutter/cupertino.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/resources/firebase_repositry.dart';

class UserProvider with ChangeNotifier {
  User _user;
  FirebaseRepositry _repositry = FirebaseRepositry();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _repositry.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
