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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Offers and Discounts",
          style: TextStyle(color: Colors.black),
        ),
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
                  Container(
                    width: 200,
                    child: Theme(
                      data: ThemeData(
                          primaryColor: ThemeColoursSeva().pallete1,
                          primaryColorDark: ThemeColoursSeva().pallete1),
                      child: TextField(
                          decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeColoursSeva().dkGreen)),
                        labelText: 'Promo Code',
                      )),
                    ),
                  ),
                  RaisedButton(
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                    onPressed: () {},
                    child: Text("Apply"),
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
