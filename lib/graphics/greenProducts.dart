import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class GreenPaintProducts extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();

    // top left graphic
    ovalPath.lineTo(width * 0.33, 0);
    ovalPath.quadraticBezierTo(width * 0.25, height * 0.12, 0, height * 0.15);
    ovalPath.close();

    paint.color = ThemeColoursSeva().vlgGreen;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
