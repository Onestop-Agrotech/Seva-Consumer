// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.2
// Date-{02-10-2020}
///
/// @fileoverview Custom Appbar : Customized Appbar used in Main Landing
///  files.
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/cartIcon.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class CustomAppBar extends PreferredSize {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double height;
  final String email;
  CustomAppBar(
      {@required this.scaffoldKey, this.height = kToolbarHeight, this.email});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColoursSeva().pallete3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
            iconSize: 28.0,
          ),
          Text(
            "Welcome",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 3.30 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              CartIcon(),
            ],
          ),
        ],
      ),
    );
  }
}
