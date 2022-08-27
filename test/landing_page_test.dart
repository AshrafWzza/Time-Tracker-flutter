import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/screens/landing_page.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuth mockAuth;
  late StreamController<User> onAuthStateChangedController;
  setUp(() {
    mockAuth = MockAuth();
    onAuthStateChangedController = StreamController<User>();
  });
  tearDown(() {
    onAuthStateChangedController.close();
  });
  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );
    await tester.pump(); //MAndatory to rebuild widget
  }

  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged) {
    onAuthStateChangedController
        .addStream(Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  // 3 possibilities 1-waiting 2-user=null->show signInPage 3-user ->show HomePage
  // 'Null' is not a subtype of type 'Stream<User?>'
  testWidgets('stream wait', (WidgetTester tester) async {
    stubOnAuthStateChangedYields([]);
    // await tester.pumpWidget(LandingPage());
    await pumpLandingPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
