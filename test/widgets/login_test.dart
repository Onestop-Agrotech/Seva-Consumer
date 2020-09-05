import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp/screens/auth/login.dart';

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(LoginScreen()));

    // final seva = find.text('Seva');
    // expect(seva, findsOneWidget);

    final signin = find.text('Sign In');
    expect(signin, findsOneWidget);

    final mobile = find.text('Mobile:');
    expect(mobile, findsOneWidget);

    final mobileTextField = find.byType(TextField);
    expect(mobileTextField, findsOneWidget);

    final getOtpButton = find.byType(RaisedButton);
    expect(getOtpButton, findsOneWidget);

    final getSignupButton = find.text("Sign up");
    expect(getSignupButton, findsOneWidget);

  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
