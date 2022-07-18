import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/home/models/job.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/components/show_alert_dialog.dart';

import '../services/database.dart';

class JobsPage extends StatelessWidget {
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

  Future<void> _creatjob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation Failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jobs'),
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
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _creatjob(context)),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data!;
            final children = jobs.map((job) => Text(job.name)).toList();
            return ListView(
              children: children,
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Errorrr'));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
