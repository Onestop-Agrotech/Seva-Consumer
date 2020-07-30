import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class ShowCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // fallback height
      height: height * 0.2,
      width: width * 0.4,
      decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColoursSeva().pallete3,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
