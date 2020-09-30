// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview FeaturedCards Widget: Reusable and Customizable Cards.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class FeaturedCards extends StatefulWidget {
  final String textToDisplay;
  FeaturedCards({this.textToDisplay});

  @override
  _FeaturedCardsState createState() => _FeaturedCardsState();
}

class _FeaturedCardsState extends State<FeaturedCards> {
  showReferralInstructions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Referrals"),
            content: Text(
                "Share your code with your friends. Ask them to share your code and their order number on our Whatsapp with their registered mobile number to receive Rs 25 cashback each. Valid only once per unique friend."),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                color: ThemeColoursSeva().pallete1,
              ),
              SizedBox(width: 20.0),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Share",
                  style: TextStyle(color: Colors.white),
                ),
                color: ThemeColoursSeva().dkGreen,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (widget.textToDisplay ==
            "Share your referral code with friends to get Rs 25 cashback")
          showReferralInstructions();
      },
      child: Container(
        // fallback height
        height: 20 * SizeConfig.heightMultiplier,
        width: width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: ThemeColoursSeva().pallete1,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),
          child: Text(
            widget.textToDisplay,
            style: TextStyle(
                color: Colors.white,
                fontSize: 2.4 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}
