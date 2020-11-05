import 'package:flutter/material.dart';

class Featured {
  final String name;
  final String imgURL;
  final bool clickable;
  final String screen;

  Featured(
      {@required this.name,
      @required this.imgURL,
      @required this.clickable,
      this.screen});
}
