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
    ovalPath.moveTo(0, height * 0.24);
    ovalPath.quadraticBezierTo(
        width * 0.78, height * 0.36, width, height * 0.3);
    ovalPath.lineTo(width, 0);
    ovalPath.lineTo(0, 0);
    ovalPath.close();

    // paint
    paint.color = ThemeColoursSeva().pallete1;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
