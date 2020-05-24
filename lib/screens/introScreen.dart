import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenIntro.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: GreenPaintBgIntro(),
              child: Center(
                child: null,
              ),
            ),
            Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "SEVA",
                        style: TextStyle(
                            fontSize: 45.0,
                            color: ThemeColoursSeva().lgGreen,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
                        child: Text(
                          "By ONESTOP",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontWeight: FontWeight.w300,
                              color: ThemeColoursSeva().lgGreen,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                top: 120),
          ],
        ),
      ),
    );
  }
}
