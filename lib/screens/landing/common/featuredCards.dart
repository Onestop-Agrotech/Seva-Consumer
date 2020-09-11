// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview FeaturedCards Widget: Reusable and Customizable Cards.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class FeaturedCards extends StatelessWidget {
  final String textToDisplay;
  FeaturedCards({this.textToDisplay});
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // fallback height
      height: 20 * SizeConfig.heightMultiplier,
      width: width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: ThemeColoursSeva().pallete1,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),
        child: Text(
          textToDisplay,
          style: TextStyle(
              color: Colors.white,
              fontSize: 2.4 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w500),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
