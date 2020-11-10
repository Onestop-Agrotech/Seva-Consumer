import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvp/screens/googleMapsPicker.dart';

void main() {
  testWidgets('Location screen test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(GoogleMapsPicker(
      userEmail: "vk.rahul318@gmail.com",
    )));

    final houseNoText = find.text('House No/Flat No:');
    expect(houseNoText, findsOneWidget);

    final landmarkText = find.text('Landmark:');
    expect(landmarkText, findsOneWidget);

    expect(find.byKey(Key("maps")), findsOneWidget);
  });
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}
