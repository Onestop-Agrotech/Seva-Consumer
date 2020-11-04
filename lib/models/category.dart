import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class Category {
  final String name;
  final String categoryName;
  Color backgroundColor;
  Color textColor;
  final bool hasData;
  final String imgURL;

  Category(
      {@required this.name,
      @required this.categoryName,
      this.backgroundColor = Colors.white,
      this.textColor,
      @required this.hasData,
      @required this.imgURL}) {
    this.textColor = ThemeColoursSeva().pallete1;
  }
}
