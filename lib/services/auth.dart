import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User> signInanonymously();
  Future<User> signInwithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmail(String email, String password);
  Future<User> RegisterWithEmail(String email, String password);

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  User? get currentUser => _firebaseAuth.currentUser;
  //make User? not .currentUser! ,, so if you want to check user is null
  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
  //authStateChanges: a firebase Auth that Notifies about changes to the user's sign-in state (such as sign-in or sign-out)
  @override
  // Future<User> signInWithEmail(TextEditingController emailController,
  //     TextEditingController passwordController) async {
  //   final userCerdentials = await _firebaseAuth.signInWithEmailAndPassword(
  //       email: emailController.text, password: passwordController.text);
  //   // Auth accepts only string so use _emailController.toString() XXXXXXXX
  //   //                             use _emailController.text
  //   // onPressed: () => _signInWithEmail(context, email!, password!),
  //   return userCerdentials.user!;
  // }
  Future<User> signInWithEmail(String email, String password) async {
    final userCerdentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    // Auth accepts only string so use _emailController.toString() XXXXXXXX
    //                             use _emailController.text
    // onPressed: () => _signInWithEmail(context, email!, password!),
    return userCerdentials.user!;
  }

  // @override
  // Future<User> RegisterWithEmail(TextEditingController emailController,
  //     TextEditingController passwordController) async {
  //   final userCerdentials = await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: emailController.text, password: passwordController.text);
  //   // Auth accepts only string so use _emailController.toString() XXXXXXXX
  //   //                             use _emailController.text
  //   // onPressed: () => _signInWithEmail(context, email!, password!),
  //   return userCerdentials.user!;
  // }
  @override
  Future<User> RegisterWithEmail(String email, String password) async {
    final userCerdentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // Auth accepts only string so use _emailController.toString() XXXXXXXX
    //                             use _emailController.text
    // onPressed: () => _signInWithEmail(context, email!, password!),
    return userCerdentials.user!;
  }

  @override
  Future<User> signInanonymously() async {
    final userCerdentials = await _firebaseAuth.signInAnonymously();
    return userCerdentials.user!;
  }

  @override
  Future<User> signInwithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user!;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING GO0GLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final fb = FacebookLogin();
    // final response = await fb.logIn(permissions: [
    //   FacebookPermission.publicProfile,
    //   FacebookPermission.email,
    // ]);
    final response = await fb.logIn();
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential.user!;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEB00K_ LOGIN_FAILED',
          message: response.error?.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
