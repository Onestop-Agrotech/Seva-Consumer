// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.2
// Date-{02-10-2020}
///
/// @fileoverview Custom Appbar : Customized Appbar used in Main Landing
///  files.
///

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/cartIcon.dart';
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:mvp/screens/googleMapsPicker.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class CustomAppBar extends PreferredSize {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double height;
  final String email;
  CustomAppBar(
      {@required this.scaffoldKey,
      this.height = kToolbarHeight,
      @required this.email});

  @override
  Size get preferredSize => Size.fromHeight(height);

  //This function shows the user's address in a dialog box
  // and the user can edit the address from their also
  _showLocation(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delivery Address:",
            style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          content: FutureBuilder(
              future: _fetchUserAddress(),
              builder: (context, data) {
                if (data.hasData) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                      height: 120.0,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              data.data,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    );
                  });
                } else
                  return Container(
                    height: 120.0,
                    width: 100.0,
                    child: Center(
                      child: CommonGreenIndicator(),
                    ),
                  );
              }),
          actions: <Widget>[
            FutureBuilder(
              future: _fetchUserAddress(),
              builder: (context, data) {
                if (data.hasData) {
                  return RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<Null>(
                          builder: (context) => GoogleMapsPicker(
                            userEmail: email,
                          ),
                        ),
                      );
                    },
                    child: Text("Change"),
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                  );
                } else
                  return Container();
              },
            ),
          ],
        );
      },
    );
  }

  //To get the address of the user address on clicking the
  // location icon
  Future<String> _fetchUserAddress() async {
    // ignore: unused_local_variable
    var mail = email;
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    String id = await p.getData("id");
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getAddressAPI + "$id";
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      // got address
      mail = json.decode(response.body)["email"];
      return (json.decode(response.body)["address"]);
    } else {
      throw Exception('something is wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColoursSeva().pallete4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
            iconSize: 28.0,
          ),
          Text(
            "Welcome to Seva",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 2.30 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: () async {
                  _showLocation(context);
                },
                iconSize: 28.0,
              ),
              CartIcon(),
            ],
          ),
        ],
      ),
    );
  }
}
