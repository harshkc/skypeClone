import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore db = Firestore.instance;
  StorageReference _storageReference;
  static final CollectionReference _userCollection = db.collection('users');
  //user model object
  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot userSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(userSnapshot.data);
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuth =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _signInAuth.idToken,
      accessToken: _signInAuth.accessToken,
    );

    AuthResult result = await _auth.signInWithCredential(credential);

    return result.user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await db
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    db.collection("users").document(currentUser.uid).setData(user.toMap(user));
  }

  Future<void> signOut() async {
    _googleSignIn.disconnect();
    _googleSignIn.signOut();
    return _auth.signOut();
  }

  Future<List<User>> getListUser(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot = await db.collection("users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; ++i) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  //To add text message to db
  Future<void> addMsgToDb(User sender, User receiver, Message message) async {
    var map = message.toMap();

    await db
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    //To keep track of all the users who contacted sender and receiver by registering
    //their Ids as documents in each other collection and then creating message collection
    // by adding message map.
    await db
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  //To store image in firebase storage
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child("${DateTime.now().millisecondsSinceEpoch}");
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  //To add image message to db
  Future<void> addImageMsgDb(
      String url, String receiverId, String senderId) async {
    Message message;

    //named constructor is called for registering values
    message = Message.imageMessage(
        message: "Image",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timeStamp: Timestamp.now(),
        type: "image");

    //creating imagemap through named image constructor
    var map = message.toImageMap(); //map = Map<String,dynamic>();

    await db
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    //To keep track of all the users who contacted sender and receiver by registering
    //their Ids as documents in each other collection and then creating message collection
    // by adding message map.
    await db
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  //driver function to get url and add image msg as document in msg collection
  void uploadImage(
    File imageFile,
    String receiverId,
    String senderId,
    ImageUploadProvider imageUploadProvider,
  ) async {
    //While image is being added to storage set the imageUploadProvider to loading
    //which is reflected on chatScreen through provider
    imageUploadProvider.setToLoading();
    //Fetch the url after image is stored
    String url = await uploadImageToStorage(imageFile);
    //set the loading to idle and show on chatScreen
    imageUploadProvider.setToIdle();
    //Now this can be added in msg collection as document and shown on chatScreen
    addImageMsgDb(url, receiverId, senderId);
  }
}
