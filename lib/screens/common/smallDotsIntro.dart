// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

/**
 * @fileoverview SmallDotIntro Widget : These are the dots that are present on the
 * home screen.
 */

import 'package:flutter/material.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class SmallDotsIntro extends StatefulWidget {
  final Color bg;
  SmallDotsIntro({this.bg});

  @override
  _SmallDotsIntroState createState() => _SmallDotsIntroState();
}

class _SmallDotsIntroState extends State<SmallDotsIntro> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.8 * SizeConfig.textMultiplier,
      width: 2.8 * SizeConfig.textMultiplier,
      decoration: BoxDecoration(color: widget.bg, shape: BoxShape.circle),
    );
  }
}
