import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/components/show_alert_dialog.dart';
import 'package:time_tracker_flutter/components/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/home/models/job.dart';
import '../../services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job; //if you pass job then EditPage , if null ? it will be Addpage
  // {Job? job} optional & nullable
  //pass database inside show() to work inside edit job page and entries page
  static Future<void> show(BuildContext context,
      {Database? database, Job? job}) async {
    // {Job? job} optional & nullable
    // error Couldn't find correct provider  above this page
    // MAndatory pass database explicitly from jobpage to addjobpage
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database!,
          job: job, //Note if you forget job:job it will always be null
          // job is optional so if passed --> EditPage ,else AddPage
        ),
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();
  bool _isLoading = false;
  @override
  void initState() {
    debugPrint(widget.job?.name);
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.ratePerHour;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _ratePerHourFocusNode.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;
  bool _validateAndSaveForm() {
    final form = _formKey.currentState; //MAndatory

    if (form!.validate()) {
      form.save();
      //error Solve Null tryParse for _ratePerHour
      // MUST check null value here after --> form.save();
      if (_name == null || _ratePerHour == null) {
        showAlertDialog(context,
            title: 'Fields can\'t be null',
            content: 'RatePerHour must have number value',
            defaultActionText: 'OK');
        return false;
      }
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          debugPrint('1111111111');
          _isLoading = true;
        });
        debugPrint('222222');
        final jobs = await widget.database.jobStream().first; // MAndatory await
        debugPrint('33333333');
        final allNames = jobs.map((job) => job.name).toList();
        debugPrint('444444444');
        //error: while Editing exclude the name from allNames to avoid showAlertDialog(title: 'Name already used')
        //another solution way to wrap if (allNames.contains(_name)) with  if (widget.job == null) ->> while adding not editing
        if (widget.job != null) {
          debugPrint('55555551');
          allNames.remove(widget.job!.name);
          debugPrint('5555555');
        }
        if (allNames.contains(_name)) {
          debugPrint('6666661');
          showAlertDialog(context,
              title: 'Name already used',
              content: 'please choose another name',
              defaultActionText: 'OK');
          setState(() {
            debugPrint('777777777');
            _isLoading = false;
          });
        } else {
          debugPrint('888888');
          //check if id null then (ADD) , if exist (Edit)
          final id = widget.job?.id ?? DateTime.now().toIso8601String();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          debugPrint('999999');
          await widget.database.setJob(job);
          debugPrint('10000000000000');
          _formKey.currentState!.reset();
          debugPrint('111111111111111');
          setState(() {
            debugPrint('12122121212121212');
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        debugPrint('22222222222222222');
        setState(() {
          _isLoading = false;
        });
        showExceptionAlertDialog(context,
            title: 'Operation Failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
              onPressed: _submit,
              child: Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 18.0)))
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: _buildContents(),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        //initialValue: _name, this will make form.reset() not work after ADD new
        //so the solution is to check if only this is Editing no Adding
        initialValue: widget.job != null ? _name : null,
        decoration: InputDecoration(labelText: 'Job Name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocusNode,
      ),
      TextFormField(
        //initialValue:'$_ratePerHour', fill field with null value and the same for _name will make form.reset() not work
        initialValue:
            _ratePerHour != null && widget.job != null ? '$_ratePerHour' : null,
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Hours can\'t be empty',
        //onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
        // 0 is not the right solution, must be null then handle null on validation
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? null,
        focusNode: _ratePerHourFocusNode,
      ),
    ];
  }
}
