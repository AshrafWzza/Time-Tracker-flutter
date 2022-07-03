import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/components/show_alert_dialog.dart';

class HomePage extends StatelessWidget {
  //final AuthBase auth;
  //final VoidCallback onSignOut; //CallBack //using StreamBuilder
  // const HomePage({Key? key, required this.auth /*required this.onSignOut*/
  //     })
  //     : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
    // onSignOut(); //CallBack //using StreamBuilder
  }

  // Show Alert Dialog To confirm whether to signout or not
  // Future<void> _confirmSignOut(BuildContext context) async {
  //   final confirmAlert = await showAlertDialog(context,
  //       title: 'LogOut',
  //       content: 'Are You Sure You Want To LogOut?',
  //       cancelActionText: 'cancel',
  //       defaultActionText: 'LogOut');
  //   if (confirmAlert == true) {
  //     _signOut();
  //   }
  // }
  Future<void> _confirmSignOut(BuildContext context) async {
    // showAlertDialog return Future<bool>
    // Mandatory await
    final confirmAlert = await showAlertDialog(context,
        title: 'LogOut',
        content: 'Are You Sure You Want To LogOut?',
        cancelActionText: 'cancel',
        defaultActionText: 'LogOut');
    // showAlertDialog return Future<bool>
    if (confirmAlert == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        //title: Text('${auth.currentUser!.uid}'),
        actions: [
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          Text(' '), //Space as Right Padding
        ],
      ),
    );
  }
}
