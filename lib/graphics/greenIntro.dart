import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class GreenPaintBgIntro extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();
    // top left graphic
    ovalPath.lineTo(width * 0.34, 0);
    ovalPath.quadraticBezierTo(
        width * 0.41, height * 0.21, width * 0.0, height * 0.30);
    ovalPath.close();

    // top right graphic
    ovalPath.moveTo(width, 0);
    ovalPath.lineTo(width * 0.85, 0);
    ovalPath.quadraticBezierTo(width * 0.65, height * 0.2, width, height * 0.4);
    ovalPath.close();

    // bottom graphic
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.97);
    ovalPath.quadraticBezierTo(
        width * 0.21, height * 0.92, width * 0.75, height * 0.89);
    ovalPath.quadraticBezierTo(
        width * 0.88, height * 0.88, width, height * 0.81);
    ovalPath.lineTo(width, height * 0.81);
    ovalPath.lineTo(width, height);
    ovalPath.close();

    paint.color = ThemeColoursSeva().vlgGreen;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
