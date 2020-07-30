import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/landing/graphics/darkBG.dart';

import 'graphics/lightBG.dart';

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: LightBlueBG(),
            child: Container(),
          ),
          CustomPaint(
            painter: DarkColourBG(),
            child: Container(),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                      iconSize: 28.0,
                    ),
                    Text(
                      "Welcome",
                      style: TextStyle(
                          color: ThemeColoursSeva().dkGreen,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () {},
                      iconSize: 28.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
