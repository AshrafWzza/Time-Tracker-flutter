import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/blocs/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/services/validation.dart';
import 'email_sign_in_model.dart';

// To Toggle between signIn & Register
// enum EmailSignInFormType { signIn, register }

// with EmailAndPasswordValidators as Mixin for Validation
class EmailSignInFormBloc extends StatefulWidget
    with EmailAndPasswordValidators {
  EmailSignInFormBloc({Key? key, required this.bloc}) : super(key: key);

  final EmailSignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBloc(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  // EmailSignInForm({
  //   required this.auth,
  // });
  // final AuthBase auth;

  @override
  State<EmailSignInFormBloc> createState() => _EmailSignInFormBlocState();
}

class _EmailSignInFormBlocState extends State<EmailSignInFormBloc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  // check if the form submitted before, to show textfield errors
  //   bool _submittedBefore = false;
  //   bool _isLoading = false;
  //   // No need after using TextEditingController()
  //   // String? email;
  //   // String? password;
  //   EmailSignInFormType _fromType =
  //       EmailSignInFormType.signIn; //set initial default value fot Toggle

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // To Toggle between signIn & Register
  void _toggleType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
    // setState(() {
    // _submittedBefore = false;
    // //Mandatory setState
    // _fromType = _fromType == EmailSignInFormType.signIn
    //     ? EmailSignInFormType.register
    //     : EmailSignInFormType.signIn;
    // //Every time you toggle, clear textfield
    // });
  }

  // Future<void> _signInWithEmail(
  //     //BuildContext context,
  //     TextEditingController emailController,
  //     TextEditingController passwordController) async {
  //   try {
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     await auth.signInWithEmail(emailController, passwordController);
  //     //Navigator.pop(context);  this way is so Tedious, you have to pass context as argument
  //     Navigator.of(context).pop(); //POP up emailsigninpage so homePage show
  //   } on FirebaseAuthException catch (e) {
  //     widget.bloc.updateWith(isLoading: false);
  //     showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
  //   }
  //   // finally {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // }
  //
  //   // onSignIn(user); //CallBack //using StreamBuilder
  // }

  // Future<void> _registerWithEmail(
  //     //BuildContext context,
  //     TextEditingController emailController,
  //     TextEditingController passwordController) async {
  //   try {
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     await auth.RegisterWithEmail(emailController.text, passwordController.text);
  //     //Navigator.pop(context);  this way is so Tedious, you have to pass context as argument
  //     Navigator.of(context).pop(); //POP up emailsigninpage so homePage show
  //   } catch (e) {
  //     widget.bloc.updateWith(isLoading: false);
  //     print(e.toString());
  //   }
  //
  //   // onSignIn(user); //CallBack //using StreamBuilder
  // }
  Future<void> _signInWithEmail(EmailSignInModel model) async {
    try {
      await widget.bloc.signInWithEmail(model.email, model.password);
      //Navigator.pop(context);  this way is so Tedious, you have to pass context as argument
      Navigator.of(context).pop();
      widget.bloc.updateWith(
          isLoading: false); //POP up emailsigninpage so homePage show
    } on FirebaseAuthException catch (e) {
      widget.bloc.updateWith(isLoading: false);
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }

    // onSignIn(user); //CallBack //using StreamBuilder
  }

  Future<void> _registerWithEmail(EmailSignInModel model) async {
    try {
      await widget.bloc.registerInWithEmail(model.email, model.password);
      //Navigator.pop(context);  this way is so Tedious, you have to pass context as argument
      Navigator.of(context).pop();
      widget.bloc.updateWith(
          isLoading: false); //POP up emailsigninpage so homePage show
    } catch (e) {
      widget.bloc.updateWith(isLoading: false);
      print(e.toString());
    }

    // onSignIn(user); //CallBack //using StreamBuilder
  }

  // Move Focus to next TextField
  void _emailEditingComplete(EmailSignInModel model) {
    // never go to next textfield if email is not valid
    final focus = widget.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(focus);
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    // To Toggle between signIn & Register
    final primaryText =
        model.formType == EmailSignInFormType.signIn ? 'Sign In' : 'Register';
    final secondaryText = model.formType == EmailSignInFormType.signIn
        ? 'Need an account?  '
        : 'Already have an account?  ';
    final thirdText =
        model.formType == EmailSignInFormType.signIn ? 'Register' : 'Sign in';
    bool validateEmailNotNull = widget.emailValidator.isValid(model.email);
    bool validatePasswordNotNull =
        widget.passwordValidator.isValid(model.password);

    return [
      TextField(
        controller: _emailController,
        // onChanged: (value) => {email = value},
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'example@example.com',
            errorText: model.submitted && !validateEmailNotNull
                ? 'Email Can\'t be empty'
                : null),
        enabled: model.isLoading == false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        // onChanged: (email) => setState(() {}), // for errorText
        // onChanged: (email) => widget.bloc.updateWith(email: email),
        onChanged: widget.bloc.updateEmail,

        focusNode: _emailFocusNode,
        onEditingComplete: () => _emailEditingComplete(model),
      ),
      TextField(
        controller: _passwordController,
        //onChanged: (value) => {password = value},
        obscureText: true, //***********
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter Your Password',
          errorText: model.submitted && !validatePasswordNotNull
              ? 'Password Can\'t be empty'
              : null,
          enabled: model.isLoading == false,
        ),
        textInputAction: TextInputAction.done,
        // onChanged: (password) => setState(() {}), // for errorText
        // onChanged: (password) => widget.bloc.updateWith(password: password),
        onChanged: widget.bloc.updatePassword,
        focusNode: _passwordFocusNode,
        //make it submit after done with password
        onEditingComplete: () => model.formType == EmailSignInFormType.signIn
            ? _signInWithEmail(model)
            : _registerWithEmail(model),
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        // Determine whether signIn or Register
        // onPressed: () => _fromType == EmailSignInFormType.signIn
        //     ? _signInWithEmail(_emailController, _passwordController)
        //     : _registerWithEmail(_emailController, _passwordController),
        onPressed: () {
          if (validateEmailNotNull &&
              validatePasswordNotNull &&
              model.isLoading == false) {
            // setState(() {
            //   _submittedBefore = true;
            //   _isLoading = true;
            // });
            widget.bloc.updateWith(submitted: true, isLoading: true);

            model.formType == EmailSignInFormType.signIn
                ? _signInWithEmail(model)
                : _registerWithEmail(model);
          } else {
            // setState(() {
            //   _submittedBefore = true;
            //   _isLoading = false;
            // });
            widget.bloc.updateWith(submitted: true, isLoading: false);
            return null;
          }
        },

        // Auth accepts only string so use _emailController.toString() XXXXXXXX
        //                             use _emailController.text
        // onPressed: () => _signInWithEmail(context, email!, password!),
        child: Text(primaryText),
      ),
      SizedBox(height: 8.0),
      Center(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: secondaryText, style: TextStyle(color: Colors.black54)),
            TextSpan(
              text: thirdText,
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // disable button if while loading
                  model.isLoading == false ? _toggleType() : null;
                  //_toggleType();
                },
            )
          ]),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    // Spinner while waiting
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;
          return ModalProgressHUD(
            inAsyncCall: model.isLoading,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: _buildChildren(model),
              ),
            ),
          );
        });
  }
}
