// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
///@fileoverview Siden nav : side drawer of the app.
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/orders/ordersScreen.dart';
import 'package:mvp/screens/profile.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Sidenav extends StatelessWidget {
  final double height;
  final double width;
  final String username;
  final String mobile;
  final String email;
  final String referralCode;
  Sidenav(
      {this.height,
      this.width,
      this.username,
      this.referralCode,
      this.mobile,
      this.email});

  /// show referral instructions with an
  /// Alert dialog
  showReferralInstructions(context, referralCode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Referral Code $referralCode",
              style: TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
            ),
            content: Text(
                "1️⃣ Share your code with friends.\n\n2️⃣ Ask them to order on the app\n\n3️⃣ Tell them to share your code and their order number on our WhatsApp number +918595179521 (with their registered number) \n\n4️⃣ You and your buddy receive Rs 25 each cashback on your orders! Yay 🥳  🎉 \n\nThis Whatsapp sharing is temporary. We're building a cool referral system!\n\nOrder amount must be above Rs 50\n\nOnly valid once per friend",
                style: TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65)),
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
                  String msg = ''' 
                  Hi, here's my referral code - $referralCode\n1️⃣ Order on the Seva App.\n2️⃣ Share your order number and my referral code on +918595179521(Seva Business Whatsapp)\n3️⃣ We both receive Rs 25 cashback each on orders above Rs 50!\nIf you don't have the app, get it now on https://bit.ly/Seva_Android_App
                  ''';
                  Share.share(msg);
                },
                child: Text(
                  "Share",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.widthMultiplier * 3.65),
                ),
                color: ThemeColoursSeva().dkGreen,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // main drawer
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              height: 50,
              decoration: BoxDecoration(color: ThemeColoursSeva().borderColor),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.green,
                          size: SizeConfig.widthMultiplier * 4.3,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "Home",
                          style: TextStyle(
                              fontSize: SizeConfig.widthMultiplier * 3.65),
                        )
                      ],
                    ),
                    Text(
                      "Seva",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.green,
                    size: SizeConfig.widthMultiplier * 4.3,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'My Account',
                    style:
                        TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return Profile(
                      username: this.username,
                      mobile: this.mobile,
                      email: this.email);
                }));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.article,
                    color: Colors.green,
                    size: SizeConfig.widthMultiplier * 4.3,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'My orders',
                    style:
                        TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return NewOrdersScreen();
                }));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.help,
                    size: SizeConfig.widthMultiplier * 4.3,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Help',
                    style:
                        TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
                  ),
                ],
              ),
              subtitle: Text(
                "Reach us on whatsapp",
                style: TextStyle(fontSize: SizeConfig.widthMultiplier * 2.3),
              ),
              onTap: () async {
                var url = DotEnv().env['MSG_URL'];
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.supervised_user_circle,
                    color: Colors.green,
                    size: SizeConfig.widthMultiplier * 4.3,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Referral code',
                    style:
                        TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
                  ),
                ],
              ),
              subtitle: Text(
                referralCode == null ? "" : referralCode,
                style: TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
              ),
              onTap: () {
                showReferralInstructions(context, referralCode);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.green,
                    size: SizeConfig.widthMultiplier * 4.3,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Share app',
                    style:
                        TextStyle(fontSize: SizeConfig.widthMultiplier * 3.65),
                  ),
                ],
              ),
              onTap: () {
                String msg = ''' 
                    Order Fresh Fruits 🍎 🍐 🍊, Vegetables 🥦 🥕 🧅 and Daily Essentials 🥚 🥛 only on Seva.\nIf you don't like what we bring, we assure you 100% instant refund.\nDownload the app now for free delivery within 45 minutes.\nAndroid app available now:\nhttps://bit.ly/Seva_Android_App
                    ''';
                Share.share(msg);
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text('App version - Beta'),
                    subtitle: Text("0.5.2+3"),
                    onTap: null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
