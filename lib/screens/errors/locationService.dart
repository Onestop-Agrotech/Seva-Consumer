// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

import 'package:flutter/cupertino.dart';

///
///@fileoverview Error @ LocationService Widget : Ask for location if not able to fetch.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/googleMapsPicker.dart';

class EnableLocationPage extends StatelessWidget {
  final String userEmail;
  EnableLocationPage({this.userEmail});
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
                "Please turn on your device location to continue.",
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
                    ),
                  ),
                );
              },
              child: Text(
                "Try Again",
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
