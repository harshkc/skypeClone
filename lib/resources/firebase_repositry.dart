import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/firebase_methods.dart';

class FirebaseRepositry {
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<User> getUserDetails() => _firebaseMethods.getUserDetails();
  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();
  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseMethods.addDataToDb(user);
  Future<void> signOut() => _firebaseMethods.signOut();
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) =>
      _firebaseMethods.getListUser(currentUser);
  Future<void> addMsgToDb(User sender, User receiver, Message message) {
    return _firebaseMethods.addMsgToDb(sender, receiver, message);
  }

  // Future<String> uploadImageToStorage(File imageFile) =>
  //     _firebaseMethods.uploadImageToStorage(imageFile);

  // Future<String> addImageMsgDb(
  //         String url, String receiverId, String senderId) =>
  //     _firebaseMethods.addImageMsgDb(url, receiverId, senderId);

  void uploadImage({
    @required File imageFile,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) =>
      _firebaseMethods.uploadImage(
          imageFile, receiverId, senderId, imageUploadProvider);
}
