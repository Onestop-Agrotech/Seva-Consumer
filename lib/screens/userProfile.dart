// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

/**
 * @fileoverview Userprofile Screen : Edit Users address by selecting the location on Google Maps. 
 */


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/users.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/errors/notServing.dart';

class UserProfileScreen extends StatefulWidget {
  final LatLng coords;
  final String userEmail;
  UserProfileScreen({this.coords, this.userEmail});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _emailEmpty = false;
  bool _loading = false;
  TextEditingController _address = new TextEditingController();

  _showLoading(context) {
    if (_loading == true) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_loading == false) {
      return Center(
        child: ButtonTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: RaisedButton(
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              setState(() {
                _loading = true;
              });
              _handleAddressAddition();
            },
            color: ThemeColoursSeva().dkGreen,
            textColor: Colors.white,
            child: Text("Save"),
          ),
        ),
      );
    }
  }

  _showEmptyError() {
    if (_emailEmpty == true) {
      return Text(
        'Please fill the address',
        style: TextStyle(color: Colors.red),
      );
    } else
      return Container();
  }

  _handleAddressAddition() async {
    UserModel user = new UserModel();
    user.latitude = widget.coords.latitude.toString();
    user.longitude = widget.coords.longitude.toString();
    user.email = widget.userEmail;
    if (_address.text == '') {
      // handle empty error
      setState(() {
        _emailEmpty = true;
        _loading = false;
      });
    } else if (_address.text != '') {
      // add to db
      user.address = _address.text;
      _submitToDb(user, context);
    }
  }

  _submitToDb(UserModel user, context) async {
    String url = APIService.registerAddressAPI;
    String getJson = userModelAddress(user);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      StorageSharedPrefs p = new StorageSharedPrefs();
      await p.setToken(json.decode(response.body)["token"]);
      await p.setUsername(json.decode(response.body)["username"]);
      await p.setId(json.decode(response.body)["id"]);
      bool far = json.decode(response.body)["far"];
      await p.setFarStatus(far.toString());
      await p.setEmail(json.decode(response.body)["email"]);
      if (!far) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/main', ModalRoute.withName('/main'));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return NotServing(
            userEmail: widget.userEmail,
          );
        }));
      }
    } else {
      throw Exception('Server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InputTextField(
            eC: _address,
            lt: "Home address:",
          ),
          _showEmptyError(),
        ],
      ),
      floatingActionButton: _showLoading(context),
    );
  }
}
