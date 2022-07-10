import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false); // Mandatory/ example:U decline, changed your mind
      rethrow;
    }
    // set isLoading to false only when successed,
    // when signIn failed the signIn page will be replaced by HomePage anyway
    // finally {
    //   _setIsLoading(false);
    // }
  }

  Future<User> signInanonymously() async =>
      await _signIn(auth.signInanonymously);
  Future<User> signInwithGoogle() async => await _signIn(auth.signInwithGoogle);
  Future<User> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
