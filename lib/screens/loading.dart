import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
// import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/introScreen.dart';
import 'package:mvp/screens/storesList.dart';
import 'dart:io';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showLoginScreen;
  String _showText;

  @override
  initState() {
    super.initState();
    _showText = "Setting Up ...";
    // check for internet connection here
    _checkConnection();
  }

  _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _checkForUserToken();
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        _showText = "Please check your network connection and try again";
      });
    }
  }

  _sendReqToServer(token) async {
    String url = APIService.mainTokenAPI;
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = json.encode({"token": token});
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      print('verified token');
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

  _changePage() {
    if (_showLoginScreen == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroScreen()));
    } else if (_showLoginScreen == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => StoresScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _showText,
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
