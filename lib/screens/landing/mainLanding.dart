import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/landing/common/featuredCards.dart';
import 'package:mvp/screens/landing/common/showCards.dart';
import 'package:mvp/screens/landing/graphics/darkBG.dart';

import 'graphics/lightBG.dart';

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  var texts = [
    "Free Delivery on your first 3 orders.\n" + "\nOrder Now!",
    "Get a cashback of Rs 30 on your 4th order!"
  ];
  Widget commonWidget(height) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        height: height * 0.22,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: <Widget>[ShowCards(), SizedBox(width: 10.0)],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  Widget commonText(height) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Best Sellers",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontWeight: FontWeight.w900,
                fontSize: 17.0),
          ),
          Text(
            "See all",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 15.0,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Text(
                              "Featured",
                              style: TextStyle(
                                  color: ThemeColoursSeva().dkGreen,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17.0),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          height: height * 0.2,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 2,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: <Widget>[
                                        FeaturedCards(
                                          textToDisplay: texts[index],
                                        ),
                                        SizedBox(width: 20.0),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      commonText(height),
                      SizedBox(height: 9.0),
                      commonWidget(height),
                      SizedBox(height: 9.0),
                      commonText(height),
                      SizedBox(height: 9.0),
                      commonWidget(height),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
