import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/common/topText.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _emailEmpty = false;
  bool _passwordEmpty = false;

  Map<String, int> _errorMap = {"email": 0, "password": 0};

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

  // password field is empty
  _showPasswordEmpty() {
    if (_passwordEmpty) {
      return Text(
        'Please fill your password',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  _handleSignIn() {
    if (_email.text == '') {
      setState(() {
        _emailEmpty = true;
        _errorMap["email"] = 1;
      });
    } else if (_email.text != '') {
      setState(() {
        _emailEmpty = false;
        if (_errorMap["email"] == 1) _errorMap["email"] = 0;
      });
      // handle
    }

    if (_password.text == '') {
      setState(() {
        _passwordEmpty = true;
        _errorMap["password"] = 1;
      });
    } else if (_password.text != '') {
      setState(() {
        _passwordEmpty = false;
        if (_errorMap["password"] == 1) _errorMap["password"] = 0;
      });
    }

    List<int> _valueList = _errorMap.values.toList();
    int sum = _valueList.reduce((a, b) => a + b);

    if(sum==0){
      print("No errors");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintBgLogin(),
            child: Center(child: null),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50.0),
                  TopText(txt: "Sign in"),
                  SizedBox(
                    height: 40.0,
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
                              fontSize: 45.0,
                              fontFamily: "Raleway"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "eva",
                            style: TextStyle(
                                fontFamily: "Raleway",
                                color: ThemeColoursSeva().lgGreen,
                                fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          InputTextField(eC: _email, lt: "Email:"),
                          _showEmailEmpty(),
                          SizedBox(
                            height: 30.0,
                          ),
                          InputTextField(
                            eC: _password,
                            lt: "Password:",
                            pwdType: true,
                          ),
                          _showPasswordEmpty(),
                          SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: RaisedButton(
                      onPressed: () {
                        _handleSignIn();
                      },
                      color: ThemeColoursSeva().dkGreen,
                      textColor: Colors.white,
                      child: Text("Sign in"),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? "),
                      Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: ThemeColoursSeva().dkGreen),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
