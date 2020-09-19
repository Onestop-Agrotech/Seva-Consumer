// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview DescriptionIntro Widget: Intro Seva loader.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class DescriptionIntro extends StatefulWidget {
  final String img;
  final String descText;

  DescriptionIntro({this.img, this.descText});
  @override
  _DescriptionIntroState createState() => _DescriptionIntroState();
}

class _DescriptionIntroState extends State<DescriptionIntro> {
  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(height: 130, child: Image(image: AssetImage(widget.img))),
        SizedBox(
          height: 1.3 * SizeConfig.textMultiplier,
        ),
        Container(
          width: sWidth * 0.79,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              widget.descText,
              style: TextStyle(
                  fontSize: 1.9 * SizeConfig.textMultiplier,
                  color: ThemeColoursSeva().dkGreen),
            ),
          ),
        ),
      ],
    );
  }
}
