import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/storesList.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showLoginScreen;
  @override
  initState() {
    super.initState();
    _checkForUserToken();
  }

  _sendReqToServer(token) async {
    String url = "http://localhost:8000/token";
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
    if (token != '' || token != null) {
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
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
          child: CircularProgressIndicator(
            backgroundColor: ThemeColoursSeva().black,
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColoursSeva().grey),
          ),
        ),
      ),
    );
  }
}
