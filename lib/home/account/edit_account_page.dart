import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:time_tracker_flutter/home/models/account.dart';
import '../../components/show_alert_dialog.dart';
import '../../components/show_exception_alert_dialog.dart';
import '../../services/database.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key, required this.database}) : super(key: key);
  final Database database;
  // final Account? account;
  static Future<void> show(BuildContext context,
      {Database? database, Account? account}) async {
    // {Database? database} optional & nullable
    // error Couldn't find correct provider  above this page
    // MAndatory pass database explicitly
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditAccountPage(
          database: database!,
        ),
      ),
    );
  }

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _name;
  bool _validateAndSaveForm() {
    final form = _formKey.currentState; //MAndatory

    if (form!.validate()) {
      form.save();
      //error Solve Null tryParse for _ratePerHour
      // MUST check null value here after --> form.save();
      if (_name == null) {
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
        // debugPrint('222222');
        // final jobs = await widget.database.jobStream().first; // MAndatory await
        // debugPrint('33333333');
        // final allNames = jobs.map((job) => job.name).toList();
        // debugPrint('444444444');
        // //error: while Editing exclude the name from allNames to avoid showAlertDialog(title: 'Name already used')
        // //another solution way to wrap if (allNames.contains(_name)) with  if (widget.job == null) ->> while adding not editing
        // if (widget.job != null) {
        //   debugPrint('55555551');
        //   allNames.remove(widget.job!.name);
        //   debugPrint('5555555');
        // }
        // if (allNames.contains(_name)) {
        //   debugPrint('6666661');
        //   showAlertDialog(context,
        //       title: 'Name already used',
        //       content: 'please choose another name',
        //       defaultActionText: 'OK');
        //   setState(() {
        //     debugPrint('777777777');
        //     _isLoading = false;
        //   });
        // }
        //else {
        debugPrint('888888');
        //check if id null then (ADD) , if exist (Edit)
        // final auth = Provider.of<AuthBase>(context, listen: false);
        //
        // final id = auth.currentUser!.uid;
        // debugPrint('$id');
        final account = Account(name: _name!);
        debugPrint('${account.name}');
        debugPrint('999999');
        await widget.database.nameAccount(account);
        debugPrint('10000000000000');
        _formKey.currentState!.reset();
        debugPrint('111111111111111');
        setState(() {
          debugPrint('12122121212121212');
          _isLoading = false;
        });
        Navigator.of(context).pop();
        //}
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
        title: const Text('Edit Accocunt'),
        actions: [
          TextButton(
              onPressed: _submit,
              child: const Text('Save',
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
    //final auth = Provider.of<AuthBase>(context, listen: false);

    return [
      TextFormField(
        //initialValue: _name, this will make form.reset() not work after ADD new
        //so the solution is to check if only this is Editing no Adding
        decoration: const InputDecoration(labelText: 'New Name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        textInputAction: TextInputAction.next,
      ),
      TextFormField(
        //initialValue: _name, this will make form.reset() not work after ADD new
        //so the solution is to check if only this is Editing no Adding
        decoration: const InputDecoration(labelText: 'New Image'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        textInputAction: TextInputAction.next,
      ),
    ];
  }
}
