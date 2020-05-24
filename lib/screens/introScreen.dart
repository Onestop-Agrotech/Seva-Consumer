import 'package:flutter/material.dart';
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
            
          ],
        ),
      ),
    );
  }
}
