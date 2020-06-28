import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class GreenPaintingBgAuth extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();

    // top right graphic
    ovalPath.moveTo(width, 0);
    ovalPath.lineTo(width * 0.77, 0);
    ovalPath.quadraticBezierTo(
        width * 0.75, height * 0.2, width, height * 0.23);
    ovalPath.close();

    // bottom left graphic
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.87);
    ovalPath.quadraticBezierTo(
        width * 0.14, height * 0.89, width * 0.32, height);
    ovalPath.close();

    // bottom right graphic
    ovalPath.moveTo(width, height);
    ovalPath.lineTo(width, height * 0.87);
    ovalPath.quadraticBezierTo(
        width * 0.86, height * 0.89, width * 0.68, height);
    ovalPath.close();

    // paint
    paint.color = ThemeColoursSeva().vlgGreen;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class GreenPaintBgLogin extends CustomPainter {
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

    // bottom left graphic
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.87);
    ovalPath.quadraticBezierTo(
        width * 0.14, height * 0.89, width * 0.32, height);
    ovalPath.close();

    // top right graphic
    ovalPath.moveTo(width, 0);
    ovalPath.lineTo(width * 0.77, 0);
    ovalPath.quadraticBezierTo(
        width * 0.75, height * 0.2, width, height * 0.23);
    ovalPath.close();

    // paint
    paint.color = ThemeColoursSeva().vlgGreen;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
