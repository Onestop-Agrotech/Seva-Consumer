// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.0
// Date-{27-09-2020}

///
///@fileoverview MainLanding Widget : This is the main landing screen after the user
///is logged in.
///
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/screens/common/cartIcon.dart';
import 'package:mvp/screens/common/sidenavbar.dart';
import 'package:mvp/screens/googleMapsPicker.dart';
import 'package:mvp/screens/landing/mainLandingContent.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';

import 'package:http/http.dart' as http;

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _address;
  String _username;
  String _mobileNumber;
  String _referralCode;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState(){
    super.initState();
    getUsername();
  }

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
                color: ThemeColoursSeva().dkGreen,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
            height: 160.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    _address,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: ThemeColoursSeva().pallete1,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<Null>(
                          builder: (context) => GoogleMapsPicker(
                            userEmail: _email,
                          ),
                        ),
                      );
                    },
                    child: Text("Change"),
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //To get the address of the user address on clicking the
  // location icon
  Future<String> _fetchUserAddress() async {
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    String id = await p.getData("id");
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getAddressAPI + "$id";
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      // got address
      _email = json.decode(response.body)["email"];
      return (json.decode(response.body)["address"]);
    } else {
      throw Exception('something is wrong');
    }
  }

  AppBar mainAppBar() {
    return AppBar(
      backgroundColor: ThemeColoursSeva().pallete4,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        color: ThemeColoursSeva().dkGreen,
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        iconSize: 28.0,
      ),
      title: FutureBuilder(
          future: _fetchUserAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _address = snapshot.data;
              return Text(
                snapshot.data,
                style:
                    TextStyle(color: ThemeColoursSeva().black, fontSize: 13.0),
                overflow: TextOverflow.ellipsis,
              );
            } else
              return Container();
          }),
      actions: [
        IconButton(
          icon: Icon(Icons.location_on_sharp),
          color: ThemeColoursSeva().dkGreen,
          onPressed: () {
            _showLocation(context);
          },
          iconSize: 28.0,
        ),
        CartIcon(),
      ],
    );
  }

  // To get the username of the person logged in
  // from local storage
  getUsername() async {
    final preferences = await Preferences.getInstance();
    final username = preferences.getData("username");
    final mobile = preferences.getData("mobile");
    setState(() {
      _username = username;
      _mobileNumber = mobile;
      _referralCode =
          "${_username[0].toUpperCase()}${_mobileNumber.substring(5, 10)}${_username[_username.length - 1].toUpperCase()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    // height and width if the device
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: mainAppBar(),
          drawer: SizedBox(
            width: width * 0.5,
            child: Sidenav(
              height: height,
              width: width,
              username: _username,
              referralCode: _referralCode,
            ),
          ),
          body: MainLandingContent()),
    );
  }
}
