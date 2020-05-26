import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenProducts.dart';
import 'package:mvp/screens/common/topText.dart';

import 'common/smallDotsIntro.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[Text("hello")],
        ),
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintProducts(),
            child: Center(child: null),
          ),
          SafeArea(
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TopText(txt: "Products"),
                    SizedBox(height: 120.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Vegetables',
                              style: TextStyle(
                                  color: ThemeColoursSeva().dkGreen,
                                  fontFamily: "Raleway",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 18.0,
                            ),
                            SmallDotsIntro(bg: ThemeColoursSeva().black),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Fruits',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Raleway",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 18.0,
                            ),
                            SmallDotsIntro(bg: ThemeColoursSeva().grey),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
              child: SearchBar(
                onItemFound: null,
                onSearch: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
