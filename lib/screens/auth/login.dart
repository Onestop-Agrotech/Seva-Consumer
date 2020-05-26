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
  TextEditingController loginCreds1;
  TextEditingController password;

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
          SafeArea(
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
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
                            InputTextField(
                                eC: loginCreds1, lt: "Email or mobile:"),
                            SizedBox(
                              height: 30.0,
                            ),
                            InputTextField(
                              eC: password,
                              lt: "Password:",
                              pwdType: true,
                            ),
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
                        onPressed: () {},
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
                              style:
                                  TextStyle(color: ThemeColoursSeva().dkGreen),
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
        ],
      ),
    );
  }
}
