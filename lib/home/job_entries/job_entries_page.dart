import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_flutter/home/job_entries/entry_page.dart';
import 'package:time_tracker_flutter/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter/home/jobs/list_item_builder.dart';
import 'package:time_tracker_flutter/home/models/entry.dart';
import 'package:time_tracker_flutter/home/models/job.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // StreamBuilder<Job> to update jobName = job.name after editing
    return StreamBuilder<Job>(
        stream: database.jobStreaming(jobId: job.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final job = snapshot.data!;
            final jobName = job.name;

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 2.0,
                title: Text(jobName),
                actions: <Widget>[
                  TextButton(
                    // style: ButtonStyle(
                    //     // fixedSize: MaterialStateProperty.all(Size(10.0, 10.0)),
                    //     padding: MaterialStateProperty.all(EdgeInsets.all(0.0))),
                    onPressed: () => EntryPage.show(
                        context: context, database: database, job: job),
                    //Not pass job -> show(context,jobxxxx) to become AddPage
                    child: Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                  TextButton(
                    child: Icon(Icons.edit, color: Colors.white, size: 16),
                    //MAndatory passing database  :
                    onPressed: () =>
                        EditJobPage.show(context, database: database, job: job),
                  ),
                ],
              ),
              body: _buildContent(context, job),
              // floatingActionButton: FloatingActionButton(
              //   child: const Icon(Icons.add),
              //   onPressed: () => EntryPage.show(
              //       context: context, database: database, job: job),
              // ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
