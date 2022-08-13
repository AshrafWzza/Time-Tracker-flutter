import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/home/account/edit_account_page.dart';
import 'package:time_tracker_flutter/home/models/account.dart';
import '../../components/show_alert_dialog.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
    // onSignOut(); //CallBack //using StreamBuilder
  }

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
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<Account>(
        stream: database.accountStreaming(accountId: auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final account = snapshot.data;
            final accountName = account!.name;
            return Scaffold(
                appBar: AppBar(
                  title: Text('Account'),
                  actions: [
                    TextButton(
                      // style: ButtonStyle(
                      //     // fixedSize: MaterialStateProperty.all(Size(10.0, 10.0)),
                      //     padding: MaterialStateProperty.all(EdgeInsets.all(0.0))),
                      onPressed: () => EditAccountPage.show(context,
                          database:
                              Provider.of<Database>(context, listen: false)),
                      //Not pass job -> show(context,jobxxxx) to become AddPage
                      child: Text('Edit',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    TextButton(
                        onPressed: () => _confirmSignOut(context),
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ],
                ),
                backgroundColor: Colors.red[400],
                body: SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity),
                    CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage('images/profile1.jpg')),
                    SizedBox(height: 5.0),
                    Text(
                      accountName,
                      style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
                    ),
                  ],
                )));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
  // @override
  // Widget build(BuildContext context) {
  //   final database = Provider.of<Database>(context, listen: false);
  //   final auth = Provider.of<AuthBase>(context, listen: false);
  //
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Account'),
  //         actions: [
  //           TextButton(
  //               onPressed: () => _confirmSignOut(context),
  //               child: Text(
  //                 'Logout',
  //                 style: TextStyle(color: Colors.white, fontSize: 16),
  //               )),
  //           TextButton(
  //             // style: ButtonStyle(
  //             //     // fixedSize: MaterialStateProperty.all(Size(10.0, 10.0)),
  //             //     padding: MaterialStateProperty.all(EdgeInsets.all(0.0))),
  //             onPressed: () => EditAccountPage.show(context,
  //                 database: Provider.of<Database>(context, listen: false)),
  //             //Not pass job -> show(context,jobxxxx) to become AddPage
  //             child: Icon(Icons.add, color: Colors.white, size: 16),
  //           ),
  //         ],
  //       ),
  //       backgroundColor: Colors.red[400],
  //       body: SafeArea(
  //           child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           SizedBox(width: double.infinity),
  //           CircleAvatar(
  //               radius: 50.0,
  //               backgroundImage: AssetImage('images/profile1.jpg')),
  //           SizedBox(height: 5.0),
  //           Text(
  //             '${auth.currentUser!.email}',
  //             style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
  //           ),
  //         ],
  //       )));
  // }
}
