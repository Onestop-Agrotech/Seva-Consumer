import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenIntro.dart';
import 'package:mvp/screens/common/descriptionIntro.dart';
import 'package:mvp/screens/common/smallDotsIntro.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

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
                    fontSize: 1.9 * SizeConfig.textMultiplier,
                    color: ThemeColoursSeva().dkGreen),
              ),
            ),
          ),
          SizedBox(
            height: 15.6 * SizeConfig.textMultiplier,
          ),
          Text(
            "Service available only in select areas of Bangalore.",
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 1.7 * SizeConfig.textMultiplier),
          ),
          SizedBox(height: 3.5 * SizeConfig.textMultiplier)
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
                "Order Fresh Fruits and Vegetables. Get it delivered or pick it up yourself.",
          ),
          DescriptionIntro(
            img: 'images/ct2.png',
            descText:
                "Super fast delivery within 30-45 mins from your nearby stores. ",
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
      minWidth: 13.5 * SizeConfig.textMultiplier,
      height: 5 * SizeConfig.textMultiplier,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: RaisedButton(
        onPressed: _index == 3
            ? () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/register', (route) => false);
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
    print(sHeight);
    return Scaffold(
      backgroundColor: Colors.white,
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
                          fontSize: 6.2 * SizeConfig.textMultiplier,
                          color: ThemeColoursSeva().lgGreen,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Text(
                        "By ONESTOP",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: ThemeColoursSeva().lgGreen,
                            fontSize: 2.1 * SizeConfig.textMultiplier),
                      ),
                    ),
                  ],
                ),
              ),
              top: 10.0 * SizeConfig.textMultiplier),
          Positioned(
            left: sWidth * 0.075,
            top: 26.8 * SizeConfig.textMultiplier,
            child: Container(
              height: sHeight * 0.80,
              width: sWidth * 0.85,
              child: Column(
                children: <Widget>[
                  _buildStack(),
                  _lastContent(context),
                  SizedBox(height: 4 * SizeConfig.textMultiplier),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _index = 0;
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
                          onTap: () {
                            setState(() {
                              _index = 1;
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
                          onTap: () {
                            setState(() {
                              _index = 2;
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
                          onTap: () {
                            setState(() {
                              _index = 3;
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
                    height: 3.5 * SizeConfig.textMultiplier,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildButton(),
                      _index == 3
                          ? FlatButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: ThemeColoursSeva().dkGreen,
                                    fontSize: 15.0),
                              ),
                              color: Colors.white,
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  _index == 3
                      ? Container()
                      : FlatButton(
                          onPressed: () {
                            setState(() {
                              _index = 3;
                            });
                          },
                          child: Text(
                            "Skip",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13.0),
                          ),
                          color: Colors.white,
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
