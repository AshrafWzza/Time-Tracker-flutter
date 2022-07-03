import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/screens/email_sign_in_model.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();
  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: _model.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    //update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    //add update model to _modelController
    _modelController.add(_model);
  }

  Future<void> signInWithEmail(
      //BuildContext context,
      email,
      password) async {
    try {
      await auth.signInWithEmail(email, password);
      //Navigator.pop(context);  this way is so Tedious, you have to pass context as argument
    } catch (e) {
      rethrow;
    } finally {}

    // onSignIn(user); //CallBack //using StreamBuilder
  }

  Future<void> registerInWithEmail(
      //BuildContext context,
      email,
      password) async {
    try {
      await auth.RegisterWithEmail(email, password);
      //Navigator.pop(context);  this way is so Tedious, you have to pass context as argument
    } catch (e) {
      rethrow;
    } finally {}

    // onSignIn(user); //CallBack //using StreamBuilder
  }
}
