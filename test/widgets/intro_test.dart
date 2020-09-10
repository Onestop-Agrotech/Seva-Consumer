// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview This a test widget.
///

import 'package:flutter/material.dart';
import 'package:mvp/screens/introScreen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Intro screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(IntroScreen()));

    final seva = find.text('Seva');
    expect(seva, findsOneWidget);

    var text2 = find.text("By ONESTOP");
    expect(text2, findsOneWidget);

    var nextbutton = find.text('Next');
    expect(nextbutton, findsOneWidget);

    var skipbutton = find.text("Skip");
    expect(skipbutton, findsOneWidget);

// remaining testing of dots and images

// finding the first dot
    var dot0 = find.byKey(Key("zero"));
    expect(dot0, findsOneWidget);
// clicking the dot
    await tester.tap(dot0);
    await tester.pump();
    expect(
        find.text(
            "Order Fresh Fruits and Vegetables. Get it delivered or pick it up yourself."),
        findsOneWidget);

    var dot1 = find.byKey(Key("one"));
    expect(dot1, findsOneWidget);

    var dot2 = find.byKey(Key("two"));
    expect(dot2, findsOneWidget);

    var dot3 = find.byKey(Key("three"));
    expect(dot3, findsOneWidget);
    // clicking the dot3
    await tester.tap(dot3);
    await tester.pump();
    expect(
        find.text(
            "In light of #Covid19, now buy your essentials while following the safety measures!"),
        findsOneWidget);

    var registerButton = find.text("Register");
    expect(registerButton, findsOneWidget);
    // clicking the register
    // await tester.tap(registerButton);
    // await tester.pump();

    // expect(find.,findsOneWidget);

    expect(find.text("Login"), findsOneWidget);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
