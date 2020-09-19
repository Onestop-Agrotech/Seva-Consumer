// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

///
/// @fileoverview Loadingscreen : Check if user is connected to internet and route as per their login status.
///

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/errors/notServing.dart';
import 'package:mvp/screens/introScreen.dart';
import 'dart:io';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showLoginScreen;
  String _showText;
  bool _connected = false;

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

  // check the connectivity of the user.
  _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _connected = true;
        _checkForUserToken();
      }
    } on SocketException catch (_) {
      setState(() {
        _showText = "Oops! No internet connection.";
      });
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
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
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
      StorageSharedPrefs p = new StorageSharedPrefs();
      String far = await p.getFarStatus();
      String email = await p.getEmail();
      if (far == "false") {
        Navigator.pushNamed(context, '/main');
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_connected) _checkConnection();
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _showText,
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
