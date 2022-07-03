import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_form.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
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
      body: SingleChildScrollView(
        // solve overflow problem
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              elevation: 5.0,
              shadowColor: Colors.lightGreen,
              child: EmailSignInForm()),
        ),
      ),
    );
  }
}
