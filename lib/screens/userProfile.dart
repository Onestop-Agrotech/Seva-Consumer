import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/users.dart';
import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/storesList.dart';
import 'package:http/http.dart' as http;

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

  _showLoading() {
    if (_loading == true) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_loading == false) {
      return ButtonTheme(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _loading = true;
            });
            _handleAddressAddition();
          },
          color: ThemeColoursSeva().dkGreen,
          textColor: Colors.white,
          child: Text("Save"),
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
      _submitToDb(user);
    }
  }

  _submitToDb(UserModel user) async {
    String url = "http://localhost:8000/api/users/register/address";
    String getJson = userModelAddress(user);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http.post(url, body: getJson, headers: headers);
    if (response.statusCode == 200) {
      // print(response.body);
      StorageSharedPrefs p = new StorageSharedPrefs();
      p.setToken(json.decode(response.body)["token"]);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StoresScreen()));
    } else {
      throw Exception('Server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InputTextField(eC: _address, lt: "Full address"),
          _showEmptyError(),
          _showLoading(),
        ],
      )),
    );
  }
}
