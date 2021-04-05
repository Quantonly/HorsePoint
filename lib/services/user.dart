import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String uid;
  UserService({this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUserData(
      String displayName, String email, String photoUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await users.doc(uid).set({
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'settings': {
        'language': prefs.getString('language'),
        'currency': 'EUR',
        'notifications': 'on'
      }
    });
  }

  Future<void> setSettings(
      String language, String currency, String notifications) async {
    return await users.doc(uid).update({
      'settings': {
        'language': language,
        'currency': currency,
        'notifications': notifications
      }
    });
  }

  Future<Map<String, dynamic>> getSettings() async {
    var response = await users.doc(uid).get().then((value) {
      return value.data();
    });
    return response;
  }
}
