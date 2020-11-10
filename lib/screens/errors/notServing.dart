// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

import 'package:flutter/cupertino.dart';
///
/// @fileoverview error @ NotServing Widget : Gives message if service not
/// available in the region.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/googleMapsPicker.dart';

class NotServing extends StatelessWidget {
  final String userEmail;
  NotServing({this.userEmail});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "We do not yet serve in your location. We are expanding everyday. Stay tuned!",
                style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30.0),
            RaisedButton(
              onPressed: () {
                // back to page
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute<Null>(
                        builder: (context) => GoogleMapsPicker(
                              userEmail: userEmail,
                            )));
              },
              child: Text(
                "Change Address",
                style: TextStyle(fontSize: 18.0),
              ),
              color: Colors.white,
              elevation: 0.0,
              textColor: ThemeColoursSeva().dkGreen,
            )
          ],
        ),
      )),
    );
  }
}
