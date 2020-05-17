import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  Timestamp timeStamp;
  String message;
  String photoUrl;

  //Only for text messages
  Message({
    @required this.message,
    @required this.receiverId,
    @required this.senderId,
    @required this.timeStamp,
    @required this.type,
  });

  //need to call when an image send is requested
  Message.imageMessage({
    @required this.message,
    @required this.receiverId,
    @required this.senderId,
    @required this.photoUrl,
    @required this.timeStamp,
    @required this.type,
  });

  //for mapping text messages
  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['message'] = this.message;
    map['type'] = this.type;
    map['timestamp'] = this.timeStamp;
    return map;
  }

  //for mapping image messages
  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['message'] = this.message;
    map['type'] = this.type;
    map['timestamp'] = this.timeStamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  //Named constructor
  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.message = map['message'];
    this.type = map['type'];
    this.timeStamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
  }
}
