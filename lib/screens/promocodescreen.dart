// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

///
/// @fileoverview PromoCodes Screen : Apply promocode on payment.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class PromoCodeScreen extends StatefulWidget {
  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  List categories = [
    'Vegetables',
    'Fruits',
    'Daily Essentials',
    'Category 1',
    'Category 2'
  ];
  int tapped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Theme(
                      data: ThemeData(
                          primaryColor: Colors.greenAccent,
                          primaryColorDark: Colors.deepOrangeAccent),
                      child: Container(
                        width: 200,
                        child: TextField(
                            decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal)),
                          labelText: 'Promo Code',
                        )),
                      )),
                  RaisedButton(
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {},
                    child: Text(
                      "Apply",
                      style: TextStyle(
                          color: ThemeColoursSeva().dkGreen, fontSize: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      )),
    );
  }
}
