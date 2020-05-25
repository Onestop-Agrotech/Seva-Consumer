import 'package:flutter/material.dart';
import 'package:mvp/graphics/greenAuth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintingBgAuth(),
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
