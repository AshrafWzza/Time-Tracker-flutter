import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/home/job_entries/date_time_picker.dart';
import 'package:time_tracker_flutter/home/job_entries/format.dart';
import 'package:time_tracker_flutter/home/models/entry.dart';
import 'package:time_tracker_flutter/home/models/job.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/services/database.dart';

class EntryPage extends StatefulWidget {
  const EntryPage(
      {Key? key, required this.database, required this.job, this.entry})
      : super(key: key);
  final Database database;
  final Job job;
  final Entry? entry;

  static Future<void> show(
      {required BuildContext context,
      required Database database,
      required Job job,
      Entry? entry}) async {
    //rootNavigator: true make Cupertino bar hidden - FullScreen
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, job: job, entry: entry)));
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late String _comment;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    //Todo: check if need to use DateTime.now().toIso8601String() instead of define it explicitly documentIdFromCurrentDate()
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      jobId: widget.job.id,
      start: start,
      end: end,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job.name),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStartDate(),
              _buildEndDate(),
              const SizedBox(height: 8.0),
              _buildDuration(),
              const SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date) => setState(() => _startDate = date),
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectedDate: (date) => setState(() => _endDate = date),
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: const InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
      //no need to setState to update comment because TextEditingController(text: _comment)
    );
  }
}
