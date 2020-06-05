import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvp/constants/themeColours.dart';
// import 'package:mvp/screens/common/inputTextField.dart';
import 'package:mvp/screens/storesList.dart';

class UserProfileScreen extends StatefulWidget {
  final LatLng coords;
  UserProfileScreen({this.coords});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _address = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Please enter full address:'),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xffebedf0),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                    width: 270.0,
                    child: TextFormField(
                        controller: _address,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ))),
              ),
          ),
          ButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StoresScreen()));
              },
              color: ThemeColoursSeva().dkGreen,
              textColor: Colors.white,
              child: Text("Save"),
            ),
          ),
        ],
      )),
    );
  }
}
