import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp/screens/location.dart';

void main() {
  testWidgets('Location screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(GoogleLocationScreen()));

    final houseNoText = find.text('House No/Flat No:');
    expect(houseNoText, findsOneWidget);

    final landmarkText = find.text('Landmark:');
    expect(landmarkText, findsOneWidget);

    // expect(
    //     find.byIcon(
    //         Icons.home,
    //     ),
    //     findsOneWidget);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
