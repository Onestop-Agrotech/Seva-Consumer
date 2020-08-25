import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/auth/register.dart';
import 'dart:convert';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _start = 60;
  bool showOTPField = false;
  bool _loading = false;
  bool _inavlidMobile = false;
  bool _invalidOTP = false;
  bool _otpLoader = false;
  final _mobileFocus = FocusNode();
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer _timer;

  @override
  initState() {
    super.initState();
    // _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startTimer() {
    _start = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 0) {
            setState(() {
              showOTPField = false;
            });
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  _showOTPLoader() {
    if (_otpLoader)
      return CircularProgressIndicator();
    else
      return Container();
  }

  _showLoader() {
    if (_loading) {
      return CircularProgressIndicator();
    } else
      return showOTPField
          ? Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text("Resend OTP in $_start seconds"),
            )
          : Container(
              child: RaisedButton(
              color: ThemeColoursSeva().dkGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _mobileFocus.unfocus();
                  setState(() {
                    _loading = true;
                    _inavlidMobile = false;
                  });
                  // Here submit the form
                  await _verifyMobile();
                  // await SmsAutoFill().listenForCode;
                }
              },
              child: const Text('Get OTP',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  )),
            ));
  }

  _showInvalidMobile() {
    if (_inavlidMobile)
      return Text(
        'Mobile number not registered!',
        style: TextStyle(color: Colors.red),
      );
    else
      return Container();
  }

  _showInvalidOTP() {
    if (_invalidOTP)
      return Text(
        'Incorrect OTP!',
        style: TextStyle(color: Colors.red),
      );
    else
      return Container();
  }

  _verifyMobile() async {
    var getJson = json.encode({"phone": _mobileController.text});
    String url = APIService.loginMobile;
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      // successfully verified phone number
      var bdy = json.decode(response.body);
      String token = bdy["token"];
      String far = bdy["far"];
      // store the returned token
      StorageSharedPrefs p = new StorageSharedPrefs();
      await p.setToken(token);
      await p.setFarStatus(far);
      setState(() {
        _loading = false;
        showOTPField = true;
      });
      _startTimer();
    } else if (response.statusCode == 404) {
      // throw error, phone number not registered
      setState(() {
        _inavlidMobile = true;
        _loading = false;
      });
    } else if (response.statusCode == 500) {
      // throw error, internal server error
      setState(() {
        _loading = false;
      });
    }
  }

  _verifyOTP(otp) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    var getJson = json.encode({"phone": _mobileController.text, "otp": otp});
    String url = APIService.verifyOTP;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": token
    };
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      StorageSharedPrefs p = new StorageSharedPrefs();
      var jsonBdy = json.decode(response.body);
      await p.setUsername(jsonBdy["username"]);
      await p.setToken(jsonBdy["token"]);
      await p.setId(jsonBdy["id"]);
      await p.setEmail(jsonBdy["email"]);
      // String far = jsonBdy["far"];
      // await p.setFarStatus(far);
      // grant access to the app
      Navigator.pushReplacementNamed(context, '/main');
    } else if (response.statusCode == 400) {
      // incorrect OTP
      setState(() {
        _otpLoader = false;
        _invalidOTP = true;
      });
    } else if (response.statusCode == 500) {
      // internal server error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: GreenPaintBgLogin(),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: ThemeColoursSeva().dkGreen,
                    fontFamily: "Raleway",
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
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
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Mobile:",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: "Raleway",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 260,
                    child: TextFormField(
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      focusNode: _mobileFocus,
                      keyboardType: TextInputType.number,
                      controller: _mobileController,

                      validator: (String val) {
                        if (val.isEmpty || val.length < 10)
                          return ('Min 10 digit number required!');
                        else
                          return (null);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ThemeColoursSeva().dkGreen),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: '+91',
                      ),
                      maxLength: 10,
                      // onTap: ,
                    ),
                  ),
                  _showInvalidMobile(),
                  SizedBox(height: 10.0),
                  showOTPField
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Text(
                                "Enter OTP:",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: "Raleway",
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 100),
                              child: OTPTextField(
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 30,
                                style: TextStyle(fontSize: 20),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                onCompleted: (pin) async {
                                  setState(() {
                                    _otpLoader = true;
                                    _invalidOTP = false;
                                  });
                                  await _verifyOTP(pin);
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  _showInvalidOTP(),
                  _showOTPLoader(),
                  _showLoader(),
                  SizedBox(
                    height: 30.0,
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
          ]),
        ),
      ),
    );
  }
}
