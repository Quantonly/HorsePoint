import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:horse_point/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final FacebookLogin _facebookLogin = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<Map<String, dynamic>> signInGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('signing_in', true);
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        if (userCredential.additionalUserInfo.isNewUser) {
          await UserService(uid: _firebaseAuth.currentUser.uid).createUserData(_firebaseAuth.currentUser.displayName, _firebaseAuth.currentUser.email, _firebaseAuth.currentUser.photoURL);
        }
      }
      return {'success': 'successfully_logged_in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') return {'error': 'account_registered_platform'};
      if (e.code == 'user-disabled') return {'error': 'account_disabled'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> signInFacebook() async {
    try {
      final result = await _facebookLogin.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn) {
        final token = result.accessToken.token;

        final credential = FacebookAuthProvider.credential(token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('signing_in', true);
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        if (userCredential.additionalUserInfo.isNewUser) {
          final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=picture.type(large)&access_token=' + token));
          Map<String, dynamic> picture = jsonDecode(graphResponse.body);
          await UserService(uid: _firebaseAuth.currentUser.uid).createUserData(_firebaseAuth.currentUser.displayName, _firebaseAuth.currentUser.email, picture['picture']['data']['url']);
          await _firebaseAuth.currentUser.updateProfile(photoURL: picture['picture']['data']['url']);
          await _firebaseAuth.currentUser.reload();
        }
      }
      return {'success': 'successfully_logged_in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') return {'error': 'account_registered_platform'};
      if (e.code == 'user-disabled') return {'error': 'account_disabled'};
      return {'error': 'something_went_wrong'};
    } catch (e) {
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> signIn({String email, String password}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('signing_in', true);
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (!_firebaseAuth.currentUser.emailVerified) {
        signOut();
        return {'error': 'email_not_verified', 'data': {email: email, password: password}};
      }
      return {'success': 'successfully_logged_in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') return {'error': 'account_disabled'};
      if (e.code == 'user-not-found') return {'error': 'email_not_found'};
      if (e.code == 'wrong-password') return {'error': 'password_incorrect'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> signUp({String firstName, String lastName, String email, String password}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _firebaseAuth.setLanguageCode(prefs.getString('language'));
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (_firebaseAuth.currentUser != null) {
        String displayName = firstName + " " + lastName;
        await _firebaseAuth.currentUser.updateProfile(displayName: displayName, photoURL: '/');
        await _firebaseAuth.currentUser.sendEmailVerification();
        await UserService(uid: _firebaseAuth.currentUser.uid).createUserData(displayName, email, _firebaseAuth.currentUser.photoURL);
        signOut();
        return {'success': 'email_vertification_send'};
      }
      return {'error': 'something_went_wrong'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') return {'error': 'email_in_use'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword({String email}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _firebaseAuth.setLanguageCode(prefs.getString('language'));
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return {'success': 'password_reset_send'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return {'error': 'email_not_found'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> resetPassword({String oldPassword, String newPassword}) async {
    try {
      AuthCredential authCredential = EmailAuthProvider.credential(email: _firebaseAuth.currentUser.email, password: oldPassword);
      await _firebaseAuth.currentUser.reauthenticateWithCredential(authCredential);
      await _firebaseAuth.currentUser.updatePassword(newPassword);
      return {'success': 'password_reset'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') return {'error': 'password_incorrect'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> changeEmail({String oldPassword, String newEmail}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _firebaseAuth.setLanguageCode(prefs.getString('language'));
      AuthCredential authCredential = EmailAuthProvider.credential(email: _firebaseAuth.currentUser.email, password: oldPassword);
      await _firebaseAuth.currentUser.reauthenticateWithCredential(authCredential);
      await _firebaseAuth.currentUser.verifyBeforeUpdateEmail(newEmail);
      return {'success': 'email_reset_send'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') return {'error': 'password_incorrect'};
      if (e.code == 'email-already-in-use') return {'error': 'email_in_use'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<Map<String, dynamic>> deleteAccount({password}) async {
    try {
      AuthCredential authCredential = EmailAuthProvider.credential(email: _firebaseAuth.currentUser.email, password: password);
      await _firebaseAuth.currentUser.reauthenticateWithCredential(authCredential);
      await UserService(uid: _firebaseAuth.currentUser.uid).deleteUserData();
      await _firebaseAuth.currentUser.delete();
      return {'success': 'user_deleted'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') return {'error': 'password_incorrect'};
      return {'error': 'something_went_wrong'};
    }
  }

  Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.disconnect();
    }
    await _facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}