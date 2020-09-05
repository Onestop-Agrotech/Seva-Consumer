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
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
