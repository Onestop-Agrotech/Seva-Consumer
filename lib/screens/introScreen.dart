import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(
              "Seva",
              style: TextStyle(
                  color: ThemeColoursSeva().lgGreen,
                  fontSize: 45.0,),
            ),
          ],
        ),
      ),
    );
  }
}
