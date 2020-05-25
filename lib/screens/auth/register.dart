import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:mvp/screens/common/inputTextField.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  int _index=0;

  TextEditingController fullName;
  TextEditingController emailAddress;
  TextEditingController password;
  TextEditingController mobile;
  TextEditingController area;
  TextEditingController address;

  IndexedStack _buildStack() {
    return IndexedStack(
      index: _index,
      children: <Widget>[
        Column(
          children: <Widget>[
            InputTextField(eC: fullName, lt: "Full Name:"),
            SizedBox(
              height: 30.0,
            ),
            InputTextField(eC: emailAddress, lt: "Email Address:"),
            SizedBox(
              height: 30.0,
            ),
           
            InputTextField(
              eC: password,
              lt: "Set Password:",
              pwdType: true,
            ),
          ],
        ),
        Column(
          children: <Widget>[
             InputTextField(
              eC: mobile,
              lt: "Mobile:",
            ),
            SizedBox(
              height: 30.0,
            ),
            InputTextField(eC: area, lt: "Select Area:"),
            
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
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Create Account",
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                          color: ThemeColoursSeva().dkGreen),
                    ),
                    SizedBox(
                      height: 20.0,
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    _buildStack(),
                    SizedBox(height: 30.0),
                    ButtonTheme(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            if(_index==0)_index++;
                            else _index--;
                          });
                        },
                        color: ThemeColoursSeva().dkGreen,
                        textColor: Colors.white,
                        child: _index==1 ? Text("Sign Up") : Text("Next"),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? "),
                        Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign in",
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
