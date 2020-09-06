import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp/screens/auth/register.dart';

void main() {
  testWidgets('it should contain username field', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(RegisterScreen()));

    final username = find.text('Username');
    expect(username, findsOneWidget);

    final usernametextfield = find.byKey(Key('mobilekey'));
    expect(usernametextfield, findsOneWidget);

    await tester.enterText(usernametextfield, 'Mobile');
    expect(find.text('Mobile'), findsOneWidget);
  });

  testWidgets('it should contain email field', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(RegisterScreen()));

    final email = find.text('Email Address:');
    expect(email, findsOneWidget);

    final emailtextfield = find.byKey(Key('emailkey'));
    expect(emailtextfield, findsOneWidget);

    await tester.enterText(emailtextfield, 'email@email.com');
    expect(find.text('email@email.com'), findsOneWidget);
  });

  testWidgets('it should contain signin button', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(RegisterScreen()));

    final signin = find.text('Sign in');
    expect(signin, findsOneWidget);
  });

  testWidgets('it should contain next button', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(RegisterScreen()));

    final nextbutton = find.byType(RaisedButton);
    expect(nextbutton, findsOneWidget);

    await tester.tap(nextbutton);
    await tester.pump();

    final mobiletextfield = find.byKey(Key('mobilekey'));
    expect(mobiletextfield, findsOneWidget);

    await tester.enterText(mobiletextfield, '1234567890');
    expect(find.text('1234567890'), findsOneWidget);

    expect(find.text('Sign Up'), findsOneWidget);

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
