import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/models/contact.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/utils/strings.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);
  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  //To add text message to db
  Future<void> addMessageToDb({
    @required Message message,
    @required User sender,
    @required User receiver,
  }) async {
    var map = message.toMap();
    //To keep track of all the users who contacted sender and receiver by registering
    //their Ids as documents in each other collection and then creating message collection
    // by adding message map.
    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    //for populating chatList and keep them in each others contact
    addToContact(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  //To add image message to db
  Future<void> addImageMsgDb(
      String url, String receiverId, String senderId) async {
    Message message;

    //named constructor is called for registering values
    message = Message.imageMessage(
      message: MESSAGE_TYPE_IMAGE,
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timeStamp: Timestamp.now(),
      type: MESSAGE_TYPE_IMAGE,
    );

    //creating imagemap through named image constructor
    var map = message.toImageMap(); //map = Map<String,dynamic>();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    //To keep track of all the users who contacted sender and receiver by registering
    //their Ids as documents in each other collection and then creating message collection
    // by adding message map.
    await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  ///Adding contacts in each others db

  //Creating getter
  DocumentReference getContactsDocuments({
    @required String of,
    @required String forContact,
  }) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  //Driver function for adding each other in each other contact field in db
  addToContact({@required String senderId, @required String receiverId}) async {
    Timestamp addedOn = Timestamp.now();

    await addToSenderContact(
        senderId: senderId, receiverId: receiverId, addedOn: addedOn);
    await addToReceiverContact(
        senderId: senderId, receiverId: receiverId, addedOn: addedOn);
  }

  Future<void> addToSenderContact({
    @required String senderId,
    @required String receiverId,
    @required Timestamp addedOn,
  }) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocuments(of: senderId, forContact: receiverId).get();

    //if the users are contacting for first time
    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: addedOn,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocuments(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
      {@required String senderId,
      @required String receiverId,
      @required Timestamp addedOn}) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocuments(of: receiverId, forContact: senderId).get();

    //if the users are contacting for first time
    if (!senderSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: addedOn,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocuments(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  ///Adding contacts in each others db

  ///fetching all the contacts to populate chatList

  Stream<QuerySnapshot> fetchAllContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  ///fetching all the contacts to populate chatList
}
