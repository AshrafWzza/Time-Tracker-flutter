// import 'package:flutter/cupertino.dart';
// import 'package:time_tracker_flutter/services/validation.dart';
//
// enum EmailSignInFormType { signIn, register }
//
// class EmailSignInModel with EmailAndPasswordValidators {
//   EmailSignInModel(
//       {this.email = '',
//       this.password = '',
//       this.formType = EmailSignInFormType.signIn,
//       this.isLoading = false,
//       this.submitted = false});
//
//   final String email;
//   final String password;
//   final EmailSignInFormType formType;
//   final bool isLoading;
//   final bool submitted;
//   String get primaryText {
//     return formType == EmailSignInFormType.signIn ? 'Sign In' : 'Register';
//   }
//
//   String? get secondaryText {
//     return formType == EmailSignInFormType.signIn
//         ? 'Need an account?  '
//         : 'Already have an account?  ';
//   }
//
//   String? get thirdText {
//     return formType == EmailSignInFormType.signIn ? 'Register' : 'Sign in';
//   }
//
//   bool get validateEmailNotNull {
//     return emailValidator.isValid(email);
//   }
//
//   bool get validatePasswordNotNull {
//     return passwordValidator.isValid(password);
//   }
//
//   EmailSignInModel copyWith({
//     String? email,
//     String? password,
//     EmailSignInFormType? formType,
//     bool? isLoading,
//     bool? submitted,
//   }) {
//     return EmailSignInModel(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       formType: formType ?? this.formType,
//       isLoading: isLoading ?? this.isLoading,
//       submitted: submitted ?? this.submitted,
//     );
//   }
// }
