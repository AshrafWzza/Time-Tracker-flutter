import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/screens/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuth mockAuth;
  setUp(() {
    mockAuth = MockAuth();
  });
  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(),
          ),
        ),
      ),
    );
  }

  /*void stubSignInWithEmailSucceed() {
    when(mockAuth.signInWithEmail(any, any))
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }*/

  group('sign in', () {
    // User can't be Null
    /* testWidgets(
        'When user doesn\'t enter email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmail is not called', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      verifyNever(mockAuth.signInWithEmail(any, any));
    });*/

    //'Null' is not a subtype of type 'Future<User?>'
    /*testWidgets(
        'When user enters email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmail is  called', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
      stubSignInWithEmailSucceed();
      const email = 'abc@abc.com';
      const password = '123456';
      // final emailField = find.byType(TextField);
      // use key because there is 2 textFields
      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);
      final passwordlField = find.byKey(Key('password'));
      expect(passwordlField, findsOneWidget);
      await tester.enterText(passwordlField, password);
      await tester.pumpAndSettle(); //MAndatory to rebuild widget
      //pumpAndSettle() wait to finish if there was animation
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      verifyNever(mockAuth.signInWithEmail(email, password)).called(1);
    });*/
  });
  //group('register', () {});
}
