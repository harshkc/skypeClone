import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skypeclone/models/call.dart';
import 'package:skypeclone/utils/strings.dart';

class CallMethods {
  //accesing the calls collection in database and using a variable to store it
  CollectionReference _callCollection =
      Firestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      _callCollection.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await _callCollection.document(call.callerId).setData(hasDialledMap);
      await _callCollection.document(call.receiverId).setData(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await _callCollection.document(call.callerId).delete();
      await _callCollection.document(call.receiverId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
