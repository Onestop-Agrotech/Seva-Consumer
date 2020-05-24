import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text(
              "SEVA APP",
              style: TextStyle(color: ThemeColoursSeva().lgGreen),
            ),
          ),
        ),
      ),
    );
  }
}
