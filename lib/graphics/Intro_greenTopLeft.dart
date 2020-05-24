import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class GreenPaintTopLeft extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();
    ovalPath.lineTo(width*0.34, 0);
    ovalPath.quadraticBezierTo(width*0.41, height*0.21, width*0.0, height*0.30);
    ovalPath.close();
    paint.color = ThemeColoursSeva().vlgGreen;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
