// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

import 'package:cached_network_image/cached_network_image.dart';

///
/// @fileoverview This a test widget.
///

import 'package:flutter/material.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp/screens/productsNew/details.dart';

void main() {
  StoreProduct p;

  testWidgets('Login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(ProductDetails(p: p)));
    // final productimage = find.text(p.name);
    // expect(productimage, findsOneWidget);
    print(p);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
