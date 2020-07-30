import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class FeaturedCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: ThemeColoursSeva().pallete1,
      ),
    );
  }
}
