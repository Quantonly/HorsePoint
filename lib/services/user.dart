import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String uid;
  UserService({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUserData(String displayName, String email, String photoUrl) async {
    return await users.doc(uid).set({
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl
    });
  }
}