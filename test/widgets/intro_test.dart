import 'package:flutter/material.dart';
import 'package:mvp/screens/introScreen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Intro screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(IntroScreen()));

    final seva = find.text('Seva');

    expect(seva, findsOneWidget);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
