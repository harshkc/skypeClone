import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/chat_methods.dart';

class StorageMethods {
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageReference;

  //user class
  User user = User();

  //To store image in firebase storage
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  //driver function to get url and add image msg as document in msg collection
  void uploadImage({
    @required File imageFile,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods _chatMethods = ChatMethods();
    //While image is being added to storage set the imageUploadProvider to loading
    //which is reflected on chatScreen through provider
    imageUploadProvider.setToLoading();
    //Fetch the url after image is stored
    String url = await uploadImageToStorage(imageFile);
    //set the loading to idle and show on chatScreen
    imageUploadProvider.setToIdle();
    //Now this can be added in msg collection as document and shown on chatScreen
    _chatMethods.addImageMsgDb(url, receiverId, senderId);
  }
}
