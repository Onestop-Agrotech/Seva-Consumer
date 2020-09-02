// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

/**
 * @fileoverview graph @ DarkBG Widget : .
 */

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class DarkColourBG extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // config
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();
    // a little dark colour bg
    ovalPath.moveTo(0, height * 0.28);
    ovalPath.quadraticBezierTo(
        width * 0.68, height * 0.38, width, height * 0.32);
    ovalPath.lineTo(width, 0);
    ovalPath.lineTo(0, 0);
    ovalPath.close();

    // paint
    paint.color = ThemeColoursSeva().pallete3;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
