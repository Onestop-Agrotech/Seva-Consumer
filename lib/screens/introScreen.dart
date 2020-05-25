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
  int _index=0;

  void changeIndex(){
    setState(() {
      if(_index==2)_index=0;
      else _index++;
    });
  }

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
                  IndexedStack(
                    index: _index,
                    children: <Widget>[
                      DescriptionIntro(
                        img: 'images/ct1.png',
                        descText:
                            "Order Fresh Fruits and Vegetables on the app. We collect from a farmer directly, and deliver to your doorstep!",
                      ),
                      DescriptionIntro(
                        img: 'images/ct2.png',
                        descText:
                            "Standard delivery in under 12 hours from order time. Faster delivery available for select products at an extra price.",
                      ),
                      DescriptionIntro(
                        img: 'images/ct3.png',
                        descText:
                            "Pay online or Cash on Delivery. A farmer directly benefits from your payment. The more you order, the better the benefit!",
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SmallDotsIntro(bg: _index==0?ThemeColoursSeva().black : ThemeColoursSeva().grey),
                      SmallDotsIntro(bg: _index==1?ThemeColoursSeva().black : ThemeColoursSeva().grey),
                      SmallDotsIntro(bg: _index==2?ThemeColoursSeva().black : ThemeColoursSeva().grey),
                      SmallDotsIntro(bg: _index==3?ThemeColoursSeva().black : ThemeColoursSeva().grey),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ButtonTheme(
                    minWidth: 90.0,
                    height: 40.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: RaisedButton(
                      onPressed: changeIndex,
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
