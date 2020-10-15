import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/productsNew/newUI.dart';

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(ProductsUINew()));
    final products = find.text("Products");
    expect(products, findsOneWidget);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
