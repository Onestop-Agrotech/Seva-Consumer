// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.0
// Date-{20-09-2020}

///
/// @fileoverview Login Widget : MobileVerification,OTP are declared here.
///

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenAuth.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:mvp/screens/errors/errorfile.dart';
import 'package:mvp/screens/errors/notServing.dart';
import 'package:mvp/screens/googleMapsPicker.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'dart:convert';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

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
  int _otpCodeLength = 6;
  // bool _readonly = true;
  FocusNode _mobileFocus;
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Timer _timer;
  final _otpEditingController = TextEditingController();
  // to check for otp in sms
  final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);

  /// ************************ PLATFORM SPECIFIC ***************************

  // platform client
  static const platform = const MethodChannel('sms_user_api');

  Future<void> _getPhoneNumber() async {
    await platform.invokeMethod("getPhoneNumber");
  }

  /// ************************ PLATFORM SPECIFIC ***************************

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();
    _mobileFocus = FocusNode();
    try {
      if (Platform.isAndroid) {
        platform.setMethodCallHandler((call) {
          switch (call.method) {
            case "phone":
              if (call.arguments.toString() == "null") {
                _mobileFocus.requestFocus();
              } else
                _mobileController.text = call.arguments.toString().substring(3);
              break;
            case "sms":
              _otpEditingController.text = call.arguments.toString();
              break;
            default:
          }
          return;
        });
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _mobileFocus.dispose();
    super.dispose();
  }

  // otp timer
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

  // shows the otp loader till the sms mssg arrives
  _showOTPLoader() {
    if (_otpLoader)
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CommonGreenIndicator(),
      );
    else
      return Container();
  }

  // basic loader
  _showLoader() {
    if (_loading) {
      return CommonGreenIndicator();
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
                }
              },
              child: Text('Get OTP',
                  style: TextStyle(
                    fontSize: 2.1 * SizeConfig.textMultiplier,
                    color: Colors.white,
                  )),
            ));
  }

  // error check for invalid mobile
  _showInvalidMobile() {
    if (_inavlidMobile)
      return Errors.mobileNotExists();
    else
      return Container();
  }

  // error check for invalid otp
  _showInvalidOTP() {
    if (_invalidOTP)
      return Errors.invalidOtp();
    else
      return Container();
  }

  // verifies the mobile
  _verifyMobile() async {
    var getJson = json.encode({"phone": _mobileController.text});
    String url = APIService.loginMobile;
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      // successfully verified phone number
      var bdy = json.decode(response.body);
      String token = bdy["token"];
      final preferences = await Preferences.getInstance();
      await preferences.setToken(token);
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

  //verifies the otp
  _verifyOTP(String otp) async {
    final preferences = await Preferences.getInstance();
    String token = await preferences.getData("token");
    var getJson = json.encode({"phone": _mobileController.text, "otp": otp});
    String url = APIService.verifyOTP;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": token
    };
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      final preferences = await Preferences.getInstance();
      var jsonBdy = json.decode(response.body);
      String far = jsonBdy["far"].toString();
      String hub = jsonBdy["hub"].toString();
      String email = jsonBdy["email"].toString();
      await preferences.setUsername(jsonBdy["username"]);
      await preferences.setToken(jsonBdy["token"]);
      await preferences.sethub(jsonBdy["hub"]);
      await preferences.setId(jsonBdy["id"]);
      await preferences.setEmail(jsonBdy["email"]);
      await preferences.setMobile(jsonBdy["mobile"]);
      await preferences.setFarStatus(far);

      // grant access to the app
      if ((far == "false" || far == null) && hub != "0")
        Navigator.pushReplacementNamed(context, '/main');
      else if (hub == "0" && (far == "false" || far == null)) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute<Null>(
            builder: (context) => GoogleMapsPicker(
              userEmail: email,
            ),
          ),
        );
      } else
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

  _onOtpCallBack(String otpCode, bool isAutofill) {
    FocusScope.of(context).unfocus();
    setState(() {
      if ((otpCode.length == _otpCodeLength && isAutofill) ||
          (otpCode.length == _otpCodeLength && !isAutofill)) {
        _verifyOTP(otpCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
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
                            }, //increases the height of cursor
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColoursSeva().dkGreen),
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: '+91',
                            ),
                            maxLength: 10,
                            onTap: () async {
                              if (Platform.isAndroid) {
                                // only Android has sms user consent api
                                if (!_mobileFocus.hasFocus) {
                                  await _getPhoneNumber();
                                }
                              }
                            },
                          ),
                        ),
                        _showInvalidMobile(),
                        showOTPField
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                        width: 320.0,
                                        child: TextFieldPin(
                                          margin: 8.0,
                                          textStyle: TextStyle(
                                              fontSize: 1.7 *
                                                  SizeConfig.textMultiplier),
                                          filled: true,
                                          filledColor: Colors.grey[100],
                                          codeLength: _otpCodeLength,
                                          boxSize: 40,
                                          onOtpCallback: (code, isAutofill) =>
                                              _onOtpCallBack(code, isAutofill),
                                        )),
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
                                  Navigator.of(context).push(
                                      CupertinoPageRoute<Null>(
                                          builder: (BuildContext context) {
                                    return RegisterScreen();
                                  }));
                                },
                                child: Text(
                                  "Sign up",
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
                ]),
              ),
            ),
          ),
        );
      });
    });
  }
}
