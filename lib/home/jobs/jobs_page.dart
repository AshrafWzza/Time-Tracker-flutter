import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter/home/jobs/empty_content.dart';
import 'package:time_tracker_flutter/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter/home/jobs/list_item_builder.dart';
import 'package:time_tracker_flutter/home/models/job.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/components/show_alert_dialog.dart';

import '../../services/database.dart';

//Todo: Scroll down automatically to latest job after adding it
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

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }

  // Future<void> _creatjob(BuildContext context) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
  //   } on FirebaseException catch (e) {
  //     showExceptionAlertDialog(context,
  //         title: 'Operation Failed', exception: e);
  //   }
  // }

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
          child: Icon(Icons.add), onPressed: () => EditJobPage.show(context)),
      //Not pass job -> show(context,jobxxxx) to become AddPage
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobStream(),
        builder: (context, snapshot) {
          // ListItemBuilder Pattern --- defined manually
          /* Watch the difference itemBuilder: (context, job) vs itemBuilder: (context, index)
          itemBuilder: (context, item) from ListItemBuilder
          itemBuilder: (context, index) from ListView.builder
          */
          return ListItemBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: ValueKey('job-${job.id}'),
              background: Container(
                color: Colors.red,
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => EditJobPage.show(context, job: job),
              ),
            ),
          );
          // if (snapshot.hasData) {
          //   final jobs = snapshot.data!;
          //   if (jobs.isNotEmpty) {
          //     final children = jobs
          //         .map((job) => JobListTile(
          //             job: job,
          //             onTap: () => EditJobPage.show(context, job: job)))
          //         .toList(); // pass job -> show(context,job) to become EditPage
          //     // MAndatory tolist()
          //     return ListView(
          //       children: children,
          //     );
          //     // OR could use ListView.builder
          //     // return ListView.builder(
          //     //   itemCount: children.length,
          //     //   itemBuilder: (context, index) {
          //     //     return children[index];
          //     //   },
          //     // );
          //   }
          //   return EmptyContent();
          // }
          // //if(!snapshot.hasData){return EmptyContent();} - use if (jobs.isNotEmpty) because
          // //it show Emptycontent at first while fetching data from firebase then show listview
          // if (snapshot.hasError) {
          //   return Center(child: Text('Errorrr'));
          // }
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
        });
  }
}
