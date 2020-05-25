import 'package:flutter/material.dart';
import 'package:mvp/graphics/greenAuth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintBgLogin(),
            child: Center(child:null),
          ),
        ],
      ),
    );
  }
}