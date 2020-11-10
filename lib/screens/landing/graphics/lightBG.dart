// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview graph @ LightBG Widget : .
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class LightBlueBG extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // config
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();

    // very light colour bg
    ovalPath.moveTo(0, height * 0.30);
    ovalPath.quadraticBezierTo(
        width * 0.6, height * 0.35, width, height * 0.325);
    ovalPath.lineTo(width, 0);
    ovalPath.lineTo(0, 0);
    ovalPath.close();

    // paint
    paint.color = ThemeColoursSeva().pallete4;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
