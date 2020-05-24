import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/Intro_greenTopLeft.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: GreenPaintTopLeft(),
              child: Container(
                child: Center(
                  child: Text("SEVA")
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
