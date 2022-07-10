import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter/services/validation.dart';
import 'package:time_tracker_flutter/screens/email_sign_in_model.dart';

import '../services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInChangeModel extends ChangeNotifier
    with EmailAndPasswordValidators {
  EmailSignInChangeModel(
      {required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryText {
    return formType == EmailSignInFormType.signIn ? 'Sign In' : 'Register';
  }

  String? get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account?  '
        : 'Already have an account?  ';
  }

  String? get thirdText {
    return formType == EmailSignInFormType.signIn ? 'Register' : 'Sign in';
  }

  bool get validateEmailNotNull {
    return emailValidator.isValid(email);
  }

  bool get validatePasswordNotNull {
    return passwordValidator.isValid(password);
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: this.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isLoading: false,
      submitted: false,
    );
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
