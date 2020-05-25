import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenIntro.dart';
import 'package:mvp/screens/common/descriptionIntro.dart';
import 'package:mvp/screens/common/smallDotsIntro.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    double sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintBgIntro(),
            child: Center(
              child: null,
            ),
          ),
          Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Seva",
                      style: TextStyle(
                          fontSize: 45.0,
                          color: ThemeColoursSeva().lgGreen,
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Text(
                        "By ONESTOP",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w300,
                            color: ThemeColoursSeva().lgGreen,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              top: 120),
          Positioned(
            left: sWidth * 0.075,
            top: sHeight * 0.32,
            child: Container(
              height: sHeight * 0.58,
              width: sWidth * 0.85,
              child: Column(
                children: <Widget>[
                  DescriptionIntro(
                    img1: 'images/person.png',
                    img2: 'images/mob.png',
                    descText: "Order Fresh Fruits and Vegetables on the app. We collect from a farmer directly!",
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SmallDotsIntro(
                        bg: ThemeColoursSeva().black
                      ),
                      SmallDotsIntro(
                        bg: ThemeColoursSeva().grey
                      ),
                      SmallDotsIntro(
                        bg: ThemeColoursSeva().grey
                      ),
                      SmallDotsIntro(
                        bg: ThemeColoursSeva().grey
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  ButtonTheme(
                    minWidth: 90.0,
                    height: 40.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: RaisedButton(
                      onPressed: (){},
                      color: ThemeColoursSeva().dkGreen,
                      textColor: Colors.white,
                      child: Text("Next"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
