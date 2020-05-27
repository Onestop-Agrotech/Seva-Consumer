import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenProducts.dart';
import 'package:mvp/screens/common/customProductCard.dart';
import 'package:mvp/screens/common/topText.dart';

import 'common/smallDotsIntro.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ScrollController _scrollController = ScrollController(); 
  TextEditingController search;
  int _index = 0;

  _buildRow(int indexNumber) {
    return ListView.builder(
      controller: _scrollController,
        itemCount: 10,
        itemBuilder: (BuildContext ctx, int index) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  indexNumber == 0 ? ProductCard(cc: Colors.lightBlue) : ProductCard(cc: Colors.lightGreen),
                  indexNumber == 0 ? ProductCard(cc: Colors.lightBlue) : ProductCard(cc: Colors.lightGreen),
                ],
              ),
              SizedBox(height:15.0)
            ],
          );
        });
  }

  IndexedStack _buildStack() {
    return IndexedStack(
      index: _index==0?0:1,
      children: <Widget>[_buildRow(_index),_buildRow(_index)],
    );
  }

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
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: TopText(txt: "Products"),
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
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  height: 64.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        child: InkWell(
                          onTap: () {
                            _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                            setState(() {
                              _index = 0;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Vegetables',
                                style: TextStyle(
                                    color: _index == 0
                                        ? ThemeColoursSeva().dkGreen
                                        : Colors.grey,
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              SmallDotsIntro(
                                  bg: _index == 0
                                      ? ThemeColoursSeva().black
                                      : ThemeColoursSeva().grey),
                            ],
                          ),
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                            setState(() {
                              _index = 1;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Fruits',
                                style: TextStyle(
                                    color: _index == 1
                                        ? ThemeColoursSeva().dkGreen
                                        : Colors.grey,
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              SmallDotsIntro(
                                  bg: _index == 1
                                      ? ThemeColoursSeva().black
                                      : ThemeColoursSeva().grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 265.0),
                child: _buildStack(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
