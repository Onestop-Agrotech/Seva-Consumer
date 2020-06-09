import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenIntro.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/common/descriptionIntro.dart';
import 'package:mvp/screens/common/smallDotsIntro.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _index = 0;

  void _changeIndex() {
    setState(() {
      if (_index == 3)
        _index = 0;
      else
        _index++;
    });
  }

  Column _lastContent(context) {
    double sWidth = MediaQuery.of(context).size.width;
    if (_index == 3) {
      return Column(
        children: <Widget>[
          Container(
            width: sWidth * 0.79,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "In light of #Covid19, now buy your essentials while following the safety measures!",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Raleway",
                    color: ThemeColoursSeva().dkGreen),
              ),
            ),
          ),
          SizedBox(
            height: 80.0,
          ),
          Text(
            "Service available only in select areas of Bangalore",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontFamily: "Raleway",
                fontSize: 15.0),
          ),
          SizedBox(height: 83.0)
        ],
      );
    } else
      return Column(
        children: <Widget>[],
      );
  }

  IndexedStack _buildStack() {
    if (_index == 3)
      return IndexedStack(
        children: <Widget>[Container(child: null)],
      );
    else {
      return IndexedStack(
        index: _index,
        children: <Widget>[
          DescriptionIntro(
              img: 'images/ct1.png',
              descText:
                  "Order Fresh Fruits and Vegetables. You can pick them up from nearby stores or have it delivered to your doorstep!",
            ),
          DescriptionIntro(
            img: 'images/ct2.png',
            descText:
                "Delivery within an hour from your local stores. They are all within 2 kms of your delivery location!",
          ),
          DescriptionIntro(
            img: 'images/ct3.png',
            descText:
                "Payments are online so you don't have to worry about #Covid-19. Orders are packed and ready for pick up or delivery!",
          ),
        ],
      );
    }
  }

  ButtonTheme _buildButton() {
    return ButtonTheme(
      minWidth: 90.0,
      height: 40.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: RaisedButton(
        onPressed: _index == 3
            ? () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              }
            : _changeIndex,
        color: ThemeColoursSeva().dkGreen,
        textColor: Colors.white,
        child: _index == 3 ? Text("Register") : Text("Next"),
      ),
    );
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
                  _buildStack(),
                  _lastContent(context),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              _index=0;
                            });
                          },
                          child: SmallDotsIntro(
                              bg: _index == 0
                                  ? ThemeColoursSeva().black
                                  : ThemeColoursSeva().grey),
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              _index=1;
                            });
                          },
                          child: SmallDotsIntro(
                              bg: _index == 1
                                  ? ThemeColoursSeva().black
                                  : ThemeColoursSeva().grey),
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              _index=2;
                            });
                          },
                          child: SmallDotsIntro(
                              bg: _index == 2
                                  ? ThemeColoursSeva().black
                                  : ThemeColoursSeva().grey),
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              _index=3;
                            });
                          },
                          child: SmallDotsIntro(
                              bg: _index == 3
                                  ? ThemeColoursSeva().black
                                  : ThemeColoursSeva().grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
