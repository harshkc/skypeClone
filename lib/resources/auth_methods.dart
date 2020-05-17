import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skypeclone/enum/user_state.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/utils/strings.dart';
import 'package:skypeclone/utils/utilities.dart';

class AuthMethods {
  ///creating objects
  static final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  ///creating objects

  //collectionRefernce for DRY implementation
  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  ///fetching loggedIn user details///
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(id).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///fetching loggedIn user details///

  ///SigningIn User///
  Future<FirebaseUser> signIn() async {
    //google signIn
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    //creating credential object for signIn purposes
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    AuthResult result = await _auth.signInWithCredential(credential);

    return result.user;
  }

  ///SigningIn User///

  ///User authentication to db///

  //checking if the user is new
  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  //Adding the new user to db
  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    User user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  ///User authentication to db///

  ///Brain of Search feature///
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      //eliminating the userId of the user so that he/she doesn't find him/herself
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  ///Brain of Search feature///

  ///Signing Out///
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  ///Signing Out///

  ///UserState Indicator///
  void setUserState({
    @required String userId,
    @required UserState userState,
  }) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.document(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();
}
