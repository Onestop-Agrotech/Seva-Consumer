import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/location.dart';

class EnableLocationPage extends StatelessWidget {
  final String userEmail;
  EnableLocationPage({this.userEmail});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "Please turn on your device location to continue.",
                style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30.0),
            RaisedButton(
              onPressed: () {
                // back to page
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoogleLocationScreen(
                              userEmail: userEmail,
                            )));
              },
              child: Text(
                "Try Again",
                style: TextStyle(fontSize: 18.0),
              ),
              color: Colors.white,
              elevation: 0.0,
              textColor: ThemeColoursSeva().dkGreen,
            )
          ],
        ),
      )),
    );
  }
}
