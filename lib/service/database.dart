import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  // collection reference
  final CollectionReference users = Firestore.instance.collection('users');

  Future updateUserData(String name) async {
    return await users.document(uid).setData({
      'name': name,
    });
  }

  Stream<QuerySnapshot> get data {
    return users.snapshots();
  }
}
