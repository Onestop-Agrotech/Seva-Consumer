// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview TopText Widget : common Text Widget.
///

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
