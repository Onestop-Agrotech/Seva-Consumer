import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _email = new TextEditingController();
  bool _loading = false;
  bool _emailEmpty = false;
  bool _wrongEmail = false;

  // invalid email
  _emailWrong() {
    if (_wrongEmail) {
      return Text(
        'Invalid email address',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // email field is empty
  _showEmailEmpty() {
    if (_emailEmpty) {
      return Text(
        'Please fill your email address',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  _showLoadingOrButton() {
    if (_loading == true) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_loading == false) {
      return ButtonTheme(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: RaisedButton(
          onPressed: () {
            // _handleSignIn();
            setState(() {
              _loading = true;
              _wrongEmail = false;
            });
            if (_email.text == "" || _email.text == null) {
              setState(() {
                _emailEmpty = true;
                _loading = false;
              });
            } else {
              _handler();
            }
          },
          color: ThemeColoursSeva().dkGreen,
          textColor: Colors.white,
          child: Text("Sign in"),
        ),
      );
    }
  }

  Map<String, dynamic> _emailToJson() => {"email": _email.text};

  // handle form
  _handler() async {
    setState(() {
      _emailEmpty = false;
    });
    String url = "http://localhost:8000/api/users/forgotPassword-mailer";
    Map<String, String> headers = {"Content-Type": "application/json"};
    var getJson = json.encode(_emailToJson());
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Email sent! Please check your email for more details.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } else if (response.statusCode == 401) {
      // non valid email address
      setState(() {
        _loading = false;
        _wrongEmail = true;
      });
    } else {
      throw Exception('Server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TopText(txt: 'Forgot Password'),
          centerTitle: true,
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InputTextField(eC: _email, lt: "Registered Email Address:"),
              SizedBox(height: 10.0),
              _showEmailEmpty(),
              _emailWrong(),
              SizedBox(height: 40.0),
              _showLoadingOrButton(),
            ],
          ),
        ),
      ),
    );
  }
}
