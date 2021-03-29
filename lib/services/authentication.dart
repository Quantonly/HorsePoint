import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final FacebookLogin _facebookLogin = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String> signInGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
        await _firebaseAuth.signInWithCredential(credential);
      }
      return "Signed in w/ google";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signInFacebook() async {
    try {
      final result = await _facebookLogin.logIn(['email']);
      if(result.status == FacebookLoginStatus.loggedIn) {
        final token = result.accessToken.token;
        final credential = FacebookAuthProvider.credential(token);
        await _firebaseAuth.signInWithCredential(credential);
      }
      return "Signed in w/ facebook";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
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