import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/screens/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  // EmailSignInPage({required this.auth});
  // final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: //SingleChildScrollView( REmove it
          // solve overflow problem
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            elevation: 5.0,
            shadowColor: Colors.lightGreen,
            child: EmailSignInFormChangeNotifier.create(context)),
      ),
    );
  }
}
