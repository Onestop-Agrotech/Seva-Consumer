// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

import 'package:flutter/cupertino.dart';
///
/// @fileoverview Loadingscreen : Check if user is connected to internet and route as per their login status.
///

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvp/classes/cartItems_box.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:mvp/screens/errors/notServing.dart';
import 'package:mvp/screens/googleMapsPicker.dart';
import 'package:mvp/screens/introScreen.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showLoginScreen;
  String _showText;
  bool _connected;
  CIBox _ciBox;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();
    _showText = "Setting Up ...";
    // check for internet connection here
    _checkConnection();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NewCartModel cart = Provider.of<NewCartModel>(context, listen: false);
    _checkForCartItemsInHive(cart);
  }

  // check the connectivity of the user.
  _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _connected = true;
        });
        _checkForUserToken();
      }
    } on SocketException catch (_) {
      setState(() {
        _connected = false;
        _showText = "Oops! No internet connection.";
      });
      final snackBar = SnackBar(
        content: Text("Please connect to the internet and try again"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  // according to the connectivity send responses to the server.
  _sendReqToServer(token) async {
    String url = APIService.mainTokenAPI;
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = json.encode({"token": token});
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      // valid token
      setState(() {
        _showLoginScreen = false;
      });
    } else if (response.statusCode == 401) {
      // invalid token
      setState(() {
        _showLoginScreen = true;
      });
    } else if (response.statusCode == 500) {
      // internal server error
      throw Exception('Server Error');
    } else {
      throw Exception('Unknown Error');
    }
    _changePage();
  }

  // looks for the token of the user.
  _checkForUserToken() async {
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    if (token != '' && token != null) {
      // there is a token, now verify
      _sendReqToServer(token);
    } else {
      // no token, so just move to login screen
      setState(() {
        _showLoginScreen = true;
      });
      _changePage();
    }
  }

  // route to the intro screen if user gets connected to the internet.
  _changePage() async {
    if (_showLoginScreen == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroScreen()));
    } else if (_showLoginScreen == false) {
      final p = await Preferences.getInstance();
      String far = await p.getData("far");
      String email = await p.getData("email");
      String hub = await p.getData("hub");
      if (far == "false" && hub != "0") {
        Navigator.pushReplacementNamed(context, '/main');
      } else if (far == "true") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotServing(
              userEmail: email,
            ),
          ),
        );
      } else if (far == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else if (far == "false" && hub == "0") {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute<Null>(
            builder: (context) => GoogleMapsPicker(
              userEmail: email,
            ),
          ),
        );
      }
    }
  }

  _checkForCartItemsInHive(NewCartModel cart) async {
    _ciBox = await CIBox.getCIBoxInstance();
    List<StoreProduct> li = _ciBox.getAllItems();
    if (li.length > 0 && cart.totalItems == 0) {
      cart.cartItemsRefill(_ciBox);
    }
  }

  _showloading() {
    if (_connected == null)
      return CommonGreenIndicator();
    else if (_connected != null) {
      if (_connected == true)
        return CommonGreenIndicator();
      else
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connected != null) {
      if (!_connected) _checkConnection();
    }
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _showloading(),
                SizedBox(height: 20.0),
                Text(
                  _showText,
                  style: TextStyle(
                      color: ThemeColoursSeva().dkGreen,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
