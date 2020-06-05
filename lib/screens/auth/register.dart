import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:mvp/models/users.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/location.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _index = 0;

  TextEditingController _username = new TextEditingController();
  TextEditingController _emailAddress = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();

  _handleSignUp() async {
    UserModel user = new UserModel();
    user.username = _username.text;
    user.email = _emailAddress.text;
    user.password = _password.text;
    user.mobile = _mobile.text;
    user.pincode = _pincode.text;
    String url = "http://10.0.2.2:8000/api/users/register";
    String getJson = userModelRegister(user);
    Map<String, String> headers = {
      "Content-Type":"application/json"
    };
    var response = await http.post(url, body: getJson, headers: headers);
    // print(getJson);
    if (response.statusCode == 200) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GoogleLocationScreen()));
      return;
    } else {
      throw Exception('error');
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
          SizedBox(width: 50.0),
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
            InputTextField(eC: _username, lt: "Username"),
            SizedBox(
              height: 30.0,
            ),
            InputTextField(eC: _emailAddress, lt: "Email Address:"),
            SizedBox(
              height: 30.0,
            ),
            InputTextField(
              eC: _password,
              lt: "Set Password:",
              pwdType: true,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            InputTextField(
              eC: _mobile,
              lt: "Mobile:",
            ),
            SizedBox(
              height: 30.0,
            ),
            InputTextField(eC: _pincode, lt: "Enter Pincode:"),
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
                    TopText(txt: "Create Account"),
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
                    Row(
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
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
