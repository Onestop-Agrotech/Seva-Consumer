// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview Register Widget : to register a new user.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:mvp/models/users.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/location.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/sizeconfig/sizeconfig.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _index = 0;

  bool _loading = false;

  bool _error = false;
  bool _emailSyntaxError = false;
  bool _mobileSyntaxError = false;

  bool _usernameEmpty = false;
  bool _emailEmpty = false;
  bool _mobileEmpty = false;

  bool _notValidMobile = false;

  Map<String, int> _errorMap = {
    "username": 0,
    "email": 0,
    "mobile": 0,
  };

  TextEditingController _username = new TextEditingController();
  TextEditingController _emailAddress = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // show loading indicator
  _showLoadingOrButton() {
    if (_loading == true) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showBack(),
          ButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  _notValidMobile = false;
                });
                setState(() {
                  if (_index == 0)
                    _index++;
                  else {
                    setState(() {
                      _loading = true;
                    });
                    _handleSignUp();
                  }
                });
              },
              color: ThemeColoursSeva().dkGreen,
              textColor: Colors.white,
              child: _index == 1 ? Text("Sign Up") : Text("Next"),
            ),
          )
        ],
      );
    }
  }

  // user field is empty
  _showUserEmpty() {
    if (_usernameEmpty == true) {
      return Text(
        'Please fill your name',
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

  // mobile field is empty
  _showMobileEmpty() {
    if (_mobileEmpty) {
      return Text(
        'Please fill your phone number',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // handle already existing email error
  _showError() {
    if (_error) {
      return Text(
        'Email already exists! please change email!',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // handle valid email type
  _showEmailError() {
    if (_emailSyntaxError == true) {
      return Text(
        'Please input correct email type',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // handle valid mobile number type
  _showMobileError() {
    if (_mobileSyntaxError == true) {
      return Text(
        'Please input 10 digit mobile number',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  // mobile number validity
  _handleMobileNumberValidity() {
    if (_notValidMobile) {
      return Text(
        'Mobile number already exists',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  _handleSignUp() async {
    UserModel user = new UserModel();
    if (_username.text == '') {
      setState(() {
        _usernameEmpty = true;
        _index = 0;
        // _errors++;
        _errorMap["username"] = 1;
      });
    } else if (_username.text != '') {
      user.username = _username.text;
      setState(() {
        _usernameEmpty = false;
        // if (_errors != 0) _errors--;
        if (_errorMap["username"] == 1) _errorMap["username"] = 0;
      });
    }

    if (_emailAddress.text == '') {
      setState(() {
        _emailEmpty = true;
        _index = 0;
        // _errors++;
        _errorMap["email"] = 1;
      });
    } else if (_emailAddress.text != '') {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailAddress.text);
      if (emailValid == true) {
        user.email = _emailAddress.text;
        setState(() {
          _emailEmpty = false;
          _emailSyntaxError = false;
          _error = false;
          // if (_errors != 0) _errors--;
          if (_errorMap["email"] == 1) _errorMap["email"] = 0;
        });
      } else {
        setState(() {
          _emailEmpty = false;
          _emailSyntaxError = true;
          _index = 0;
          _errorMap["email"] = 1;
        });
      }
    }

    if (_mobile.text == '') {
      setState(() {
        _mobileEmpty = true;
        _errorMap["mobile"] = 1;
      });
    } else if (_mobile.text != '') {
      bool mobileValid = RegExp(r"^[0-9]{10}$").hasMatch(_mobile.text);
      if (mobileValid == true) {
        user.mobile = _mobile.text;
        setState(() {
          _mobileEmpty = false;
          _mobileSyntaxError = false;
          if (_errorMap["mobile"] == 1) _errorMap["mobile"] = 0;
        });
      } else {
        setState(() {
          _mobileEmpty = false;
          _mobileSyntaxError = true;
          _errorMap["mobile"] = 1;
        });
      }
    }

    List<int> _valueList = _errorMap.values.toList();
    int sum = _valueList.reduce((a, b) => a + b);

    if (sum == 0 && _error == false) {
      String url = APIService.registerAPI;
      String getJson = userModelRegister(user);
      Map<String, String> headers = {"Content-Type": "application/json"};
      var response = await http.post(url, body: getJson, headers: headers);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoogleLocationScreen(
                      userEmail: user.email,
                    )));
        return;
      } else if (response.statusCode == 400) {
        // user email already exists
        setState(() {
          _index = 0;
          _error = true;
        });
      } else if (response.statusCode == 401) {
        // user email already exists
        setState(() {
          _index = 1;
          _error = true;
          _notValidMobile = true;
          _loading = false;
        });
      } else {
        // some other error here
        throw Exception('Server error');
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  _showBack() {
    if (_index == 1) {
      return Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              }),
          SizedBox(width: 7.9 * SizeConfig.textMultiplier),
        ],
      );
    } else
      return Container();
  }

  IndexedStack _buildStack() {
    return IndexedStack(
      index: _index,
      children: <Widget>[
        Column(
          children: <Widget>[
            InputTextField(
              eC: _username,
              lt: "Username",
              key: Key('usernamekey'),
            ),
            _showUserEmpty(),
            SizedBox(
              height: 1.5 * SizeConfig.textMultiplier,
            ),
            InputTextField(
                eC: _emailAddress,
                lt: "Email Address:",
                keyBoardType: TextInputType.emailAddress,
                key: Key('emailkey')),
            _showEmailEmpty(),
            _showEmailError(),
            _showError(),
            SizedBox(
              height: 2.2 * SizeConfig.textMultiplier,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            InputTextField(
              key: Key('mobilekey'),
              eC: _mobile,
              lt: "Mobile:",
              keyBoardType: TextInputType.phone,
            ),
            _showMobileEmpty(),
            _showMobileError(),
            _handleMobileNumberValidity(),
            SizedBox(
              height: 4.1 * SizeConfig.textMultiplier,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintingBgAuth(),
            child: Center(
              child: null,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      TopText(txt: "Create Account"),
                      SizedBox(
                        height: 1.8 * SizeConfig.textMultiplier,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "S",
                              style: TextStyle(
                                color: ThemeColoursSeva().lgGreen,
                                fontSize: 5.25 * SizeConfig.textMultiplier,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "eva",
                                style: TextStyle(
                                    color: ThemeColoursSeva().lgGreen,
                                    fontSize: 2.90 * SizeConfig.textMultiplier),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3.0 * SizeConfig.textMultiplier,
                      ),
                      _buildStack(),
                      // SizedBox(height: 4.6 * SizeConfig.textMultiplier),
                      _showLoadingOrButton(),
                      SizedBox(height: 3 * SizeConfig.textMultiplier),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account? "),
                          Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: ThemeColoursSeva().dkGreen),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
