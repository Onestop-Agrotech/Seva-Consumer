// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview Login Widget : MobileVerification,OTP are declared here.
///

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/errors/notServing.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'dart:convert';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

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
  bool _readonly = true;
  final _mobileFocus = FocusNode();
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer _timer;
  SmsUserConsent smsUserConsent;
  final _otpEditingController = TextEditingController();
  // to check for otp in sms
  final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);

  @override
  initState() {
    super.initState();
    // _startTimer();
    smsUserConsent = SmsUserConsent(
        // to read the users phone number
        phoneNumberListener: () => {
              if (smsUserConsent.selectedPhoneNumber == null)
                {
                  this.setState(() {
                    _readonly = false;
                  }),
                  _mobileFocus.requestFocus(),
                  print("null is here"),
                }
              else
                {
                  this.setState(() {
                    _readonly = true;
                  }),
                  setState(() {
                    _mobileController.text =
                        smsUserConsent.selectedPhoneNumber.substring(3);
                  }),
                }
            },
        // to read users sms
        smsListener: () => {
              setState(() {
                _otpEditingController.text = intRegex
                    .allMatches(smsUserConsent.receivedSms)
                    .map((m) => m.group(0))
                    .toString()
                    .substring(2, 8);
              })
            });
  }

  @override
  void dispose() {
    // _timer.cancel();
    smsUserConsent.dispose();
    super.dispose();
  }

  _startTimer() {
    _start = 60;
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 0) {
            setState(() {
              showOTPField = false;
              _invalidOTP = false;
              _otpEditingController.clear();
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
              child: Text('Get OTP',
                  style: TextStyle(
                    fontSize: 2.1 * SizeConfig.textMultiplier,
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
    this.setState(() {
      _readonly = true;
    });
    var getJson = json.encode({"phone": _mobileController.text});
    String url = APIService.loginMobile;
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      // successfully verified phone number
      smsUserConsent.requestSms();
      var bdy = json.decode(response.body);
      String token = bdy["token"];
      StorageSharedPrefs p = new StorageSharedPrefs();
      await p.setToken(token);
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
      await p.sethub(jsonBdy["hub"]);
      print('hub,$jsonBdy["hub"]');
      await p.setEmail(jsonBdy["email"]);
      String far = jsonBdy["far"].toString();
      await p.setFarStatus(far);
      // grant access to the app
      if (far == "false" || far == null)
        Navigator.pushReplacementNamed(context, '/main');
      else
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotServing(
              userEmail: jsonBdy["email"],
            ),
          ),
        );
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
          child: SafeArea(
            child: ListView(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 3.1 * SizeConfig.textMultiplier,
                      color: ThemeColoursSeva().dkGreen,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 2.00 * SizeConfig.textMultiplier),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
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
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 3.11 * SizeConfig.textMultiplier),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Mobile:",
                      style: TextStyle(
                        fontSize: 2.8 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.0 * SizeConfig.textMultiplier),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 260,
                      child: TextFormField(
                        onTap: () {
                          smsUserConsent.requestPhoneNumber();
                          this.setState(() {
                            _readonly = true;
                          });
                        },

                        enableInteractiveSelection: true,
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        focusNode: _mobileFocus,
                        readOnly: _readonly,
                        keyboardType: TextInputType.number,
                        controller: _mobileController,

                        validator: (String val) {
                          if (val.isEmpty || val.length < 10)
                            return ('Min 10 digit number required!');
                          else
                            return (null);
                        }, //increases the height of cursor
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
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
                    // SizedBox(height: 1.2 * SizeConfig.textMultiplier),
                    showOTPField
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "OTP",
                                style: TextStyle(
                                  fontSize: 24.0,
                                ),
                              ),
                              Center(
                                child: PinCodeTextField(
                                  autofocus: false,
                                  controller: _otpEditingController,
                                  hideCharacter: false,
                                  highlight: true,
                                  highlightColor: Colors.blue,
                                  defaultBorderColor: Colors.black,
                                  hasTextBorderColor: Colors.green,
                                  maxLength: 6,
                                  onTextChanged: (text) {
                                    if (text.length == 6) {
                                      setState(() {
                                        _otpLoader = true;
                                        _invalidOTP = false;
                                      });
                                      _verifyOTP(text);
                                    }
                                  },
                                  onDone: (text) {},
                                  pinBoxWidth: 25,
                                  pinBoxHeight: 40,
                                  hasUnderline: false,
                                  wrapAlignment: WrapAlignment.spaceAround,
                                  pinBoxDecoration: ProvidedPinBoxDecoration
                                      .underlinedPinBoxDecoration,
                                  pinTextStyle: TextStyle(fontSize: 15.0),
                                  pinTextAnimatedSwitcherTransition:
                                      ProvidedPinBoxTextAnimation
                                          .scalingTransition,
                                  pinTextAnimatedSwitcherDuration:
                                      Duration(milliseconds: 300),
                                  highlightAnimationBeginColor: Colors.black,
                                  highlightAnimationEndColor: Colors.white12,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    _showInvalidOTP(),
                    _showOTPLoader(),
                    _showLoader(),
                    SizedBox(height: 3 * SizeConfig.textMultiplier),
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
              // SizedBox(
              //   height: MediaQuery.of(context).viewInsets.bottom,
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}
