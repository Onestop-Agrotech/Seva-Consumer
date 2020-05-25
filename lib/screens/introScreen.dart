import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenIntro.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/person.png'),
                      ),
                      Image(
                        image: AssetImage('images/mob.png'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: sWidth * 0.7,
                    child: Text(
                      "Order Fresh Fruits and Vegetables from the comfort of your home. We collect from farmers driectly!",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Raleway",
                          color: ThemeColoursSeva().dkGreen),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                            color: ThemeColoursSeva().black,
                            shape: BoxShape.circle),
                      ),
                      Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                            color: ThemeColoursSeva().grey,
                            shape: BoxShape.circle),
                      ),
                      Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                            color: ThemeColoursSeva().grey,
                            shape: BoxShape.circle),
                      ),
                      Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                            color: ThemeColoursSeva().grey,
                            shape: BoxShape.circle),
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
