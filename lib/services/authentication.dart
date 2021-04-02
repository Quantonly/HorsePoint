import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:horse_point/services/user.dart';

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
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        if (userCredential.additionalUserInfo.isNewUser) {
          await UserService(uid: _firebaseAuth.currentUser.uid).createUserData(_firebaseAuth.currentUser.displayName, _firebaseAuth.currentUser.email, _firebaseAuth.currentUser.photoURL);
        }
      }
      return {'success': 'Successfully logged in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') return {'error': 'Account is already registered via another platform'};
      if (e.code == 'user-disabled') return {'error': 'This account has been disabled'};
      return {'error': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> signInFacebook() async {
    try {
      final result = await _facebookLogin.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn) {
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=picture&access_token=${token}'));
        Map<String, dynamic> picture = jsonDecode(graphResponse.body);

        final credential = FacebookAuthProvider.credential(token);
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        await _firebaseAuth.currentUser.updateProfile(photoURL: picture['picture']['data']['url']);
        await _firebaseAuth.currentUser.reload();
        if (userCredential.additionalUserInfo.isNewUser) {
          await UserService(uid: _firebaseAuth.currentUser.uid).createUserData(_firebaseAuth.currentUser.displayName, _firebaseAuth.currentUser.email, _firebaseAuth.currentUser.photoURL);
        }
      }
      return {'success': 'Successfully logged in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') return {'error': 'Account is already registered via another platform'};
      if (e.code == 'user-disabled') return {'error': 'This account has been disabled'};
      return {'error': 'Something went wrong'};
    } catch (e) {
      return {'error': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (!_firebaseAuth.currentUser.emailVerified) {
        signOut();
        return {'error': 'Email is not verified', 'data': {email: email, password: password}};
      }
      return {'success': 'Successfully logged in'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') return {'error': 'This account has been disabled'};
      if (e.code == 'user-not-found') return {'error': 'Email not found'};
      if (e.code == 'wrong-password') return {'error': 'Password is incorrect'};
      return {'error': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> signUp({String firstName, String lastName, String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (_firebaseAuth.currentUser != null) {
        String displayName = firstName + " " + lastName;
        await _firebaseAuth.currentUser.updateProfile(displayName: displayName, photoURL: '/');
        await _firebaseAuth.currentUser.sendEmailVerification();
        await UserService(uid: _firebaseAuth.currentUser.uid).createUserData(displayName, email, _firebaseAuth.currentUser.photoURL);
        signOut();
        return {'success': 'Email vertification has been send'};
      }
      return {'error': 'Something went wrong'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') return {'error': 'This email is already in use'};
      return {'error': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return {'success': 'Password reset email has been send'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return {'error': 'Email not found'};
      return {'error': 'Something went wrong'};
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