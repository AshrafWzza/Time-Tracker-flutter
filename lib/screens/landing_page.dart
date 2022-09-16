import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/home/home_page.dart';
import 'package:time_tracker_flutter/screens/sign_in_page.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/services/database.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  // final AuthBase auth;
  // LandingPage({required this.auth});
  //USING STREAMBUILDER
//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }
//
// class _LandingPageState extends State<LandingPage> {
  // User? _user;
  // @override
  // void initState() {
  //   super.initState();
  //   _updateUser(widget.auth.currentUser); //stay loggedIn if u close & open app
  // }
  //
  // void _updateUser(User? user) {
  //   setState(() {
  //     _user = user;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
        stream: auth.authStateChanges(), //StreamSubscription Not StreController
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // final   user = snapshot.data;
            final user = snapshot.data;
            // as User as User as User
            if (user == null) {
              return SignInPage.create(context); //Mandatory For Blocs

            }
            return Provider<Database>(
                //create: (_) => FirestoreDatabase(uid: user.uid),
                create: (_) => FirestoreDatabase(uid: auth.currentUser!.uid),
                child: const HomePage());
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });

    //   if (_user == null) {
    //     return SignInPage(
    //       auth: widget.auth,
    //       onSignIn: _updateUser,
    //       //onSignIn:(user) => _updateUser(user),
    //     );
    //   }
    //   return HomePage(
    //     onSignOut: () => _updateUser(null),
    //   );
    // }
  }
}
