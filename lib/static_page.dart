import 'package:flutter/material.dart';

class StaticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Under Construction",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "We'll be back soon!",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
