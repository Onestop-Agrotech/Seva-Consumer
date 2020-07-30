import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class LightBlueBG extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    // config
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path ovalPath = Path();

    // very light colour bg
    ovalPath.moveTo(0, height*0.3);
    ovalPath.quadraticBezierTo(width*0.7, height*0.42, width, height*0.32);
    ovalPath.lineTo(width, 0);
    ovalPath.lineTo(0, 0);
    ovalPath.close();

    // paint
    paint.color = ThemeColoursSeva().vlgColor;
    canvas.drawPath(ovalPath, paint);
  }

   @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}