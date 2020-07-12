import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class TopText extends StatelessWidget {
  final String txt;

  TopText({this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          color: ThemeColoursSeva().dkGreen),
      overflow: TextOverflow.fade,
    );
  }
}
