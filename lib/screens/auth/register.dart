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
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/errors/errorfile.dart';
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
  bool _notValidMobile = false;

  final _formKey = GlobalKey<FormState>();

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
          child: CommonGreenIndicator(),
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
                  if (_index == 0)
                    _index++;
                  else {
                    // setState(() {
                    //   _loading = true;
                    // });
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

  // handle already existing email error
  _showError() {
    if (_error) {
      return Errors.emailExists();
    } else
      return Container();
  }

  // mobile number validity
  _handleMobileNumberValidity() {
    if (_notValidMobile) {
      return Errors.mobileNumberExists();
    } else
      return Container();
  }

  // sign up validity and api call for registerung the user
  _handleSignUp() async {
    setState(() {
      _error = false;
      _notValidMobile = false;
    });
    List<int> _valueList = _errorMap.values.toList();
    int sum = _valueList.reduce((a, b) => a + b);
    if (_formKey.currentState.validate()) {
      UserModel user = new UserModel();
      user.email = _emailAddress.text;
      user.mobile = _mobile.text;
      user.username = _username.text;
      if (sum == 0) {
        setState(() {
          _loading = true;
        });
        String getJson = userModelRegister(user);
        String url = APIService.registerAPI;
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
            _loading = false;
          });
        } else if (response.statusCode == 401) {
          // user mobile already exists
          setState(() {
            _index = 1;
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
    } else {
      if (_mobile.text.isEmpty) {
        return _index = 1;
      }
      setState(() {
        _index = 0;
      });
    }
  }

  // back icon on the registration screen
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

  // registration screen
  _buildStack() {
    return Form(
      key: _formKey,
      child: IndexedStack(
        index: _index,
        children: <Widget>[
          Column(
            children: <Widget>[
              InputTextField(
                  key: Key("username"),
                  labelText: "Username",
                  controller: _username,
                  textInputType: TextInputType.text),
              SizedBox(
                height: 1.5 * SizeConfig.textMultiplier,
              ),
              InputTextField(
                  key: Key("emailkey"),
                  labelText: "Email",
                  controller: _emailAddress,
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 2.2 * SizeConfig.textMultiplier,
              ),
              _showError()
            ],
          ),
          Column(
            children: <Widget>[
              InputTextField(
                key: Key("mobilekey"),
                labelText: "Mobile",
                controller: _mobile,
                textInputType: TextInputType.number,
              ),
              _handleMobileNumberValidity(),
              SizedBox(
                height: 4.1 * SizeConfig.textMultiplier,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // animated Route to Shoppingcart screen
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
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
                                        fontSize:
                                            2.90 * SizeConfig.textMultiplier),
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
                                    Navigator.of(context)
                                        .push(_createRoute(LoginScreen()));
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
      });
    });
  }
}
