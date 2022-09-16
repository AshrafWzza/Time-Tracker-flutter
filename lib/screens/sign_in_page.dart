import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/screens/email_sign_in_page.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/blocs/sign_in_manager.dart';

class SignInPage extends StatelessWidget {
  //SignInPage({required this.bloc});
  const SignInPage({Key? key, required this.manager, required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
              builder: (_, bloc, __) =>
                  SignInPage(manager: bloc, isLoading: isLoading.value)),
          //isLoading.value isLoading.value
          // dispose: (_, bloc) => bloc.dispose(),
        ),
      ),
    );
  }

// SignInPage({
  void _showSignInError(BuildContext context, Exception exception) {
    // in ios shows alert if you want to sign in with google ar not
    // so this Condition if you press cancel and changed your mind
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  //Mandatory with Provider pass (BuildContext context)
  Future<void> _signInanonymously(BuildContext context) async {
    try {
      //setState(() {_isLoading = true;});
      // bloc.setIsLoading(true);
      // final auth = Provider.of<AuthBase>(context, listen: false);
      // await auth.signInanonymously();
      await manager.signInanonymously();
      //setState(() {_isLoading = false;});
      //Use Finally to make it run even if there is error
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
    //finally {
    //   //setState(() {_isLoading = false;});
    //   bloc.setIsLoading(false);
    // }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      //setState(() {_isLoading = true;});
      // bloc.setIsLoading(true);
      // final auth = Provider.of<AuthBase>(context, listen: false);
      // await auth.signInwithGoogle();
      await manager.signInwithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
    // finally {
    //   //setState(() {_isLoading = false;});
    //   bloc.setIsLoading(false);
    // }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      //setState(() {_isLoading = true;});
      // bloc.setIsLoading(true);
      // final auth = Provider.of<AuthBase>(context, listen: false);
      // await auth.signInWithFacebook();
      await manager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
    // finally {
    //   //setState(() {_isLoading = false;});
    //   bloc.setIsLoading(false);
    // }
  }

  void _SignInWithEmail(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EmailSignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Time Tracker'),
        centerTitle: true,
      ),
      // body: StreamBuilder<bool>(
      //     stream: bloc.isLoadingStream,
      //     initialData: false,
      //     builder: (context, snapshot) {
      //       return _buildContainer(context, snapshot.data!);
      //     }),
      body: _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return ModalProgressHUD(
      //Spinner After your Press any Button
      inAsyncCall: isLoading,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/google-logo.png'),
                    //FractionallySizedBox(widthFactor: 0.1),
                    const Text('Sign In with Google',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    const SizedBox(width: 30.0),
                  ]),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () => _signInWithFacebook(context),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/facebook-logo.png'),
                    //FractionallySizedBox(widthFactor: 0.1),
                    const Text('Sign In with Facebook',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    const SizedBox(width: 30.0),
                  ]),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF3f62a9))),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () => _SignInWithEmail(context),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Opacity(
                      opacity: 0.0,
                      child: Icon(
                        Icons.facebook,
                        color: Colors.green,
                        size: 30.0,
                      ),
                    ),
                    //FractionallySizedBox(widthFactor: 0.1),
                    Text('Sign In with Email',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    SizedBox(width: 30.0),
                  ]),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('or',
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center),
            ),
            ElevatedButton(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Opacity(
                      opacity: 0.0,
                      child: Icon(
                        Icons.facebook,
                        color: Colors.grey,
                        size: 30.0,
                      ),
                    ),
                    //FractionallySizedBox(widthFactor: 0.1),
                    Text('Go Anonymous',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    SizedBox(width: 30.0),
                  ]),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () => _signInanonymously(context),
            ),
          ],
        ),
      ),
    );
  }
}
