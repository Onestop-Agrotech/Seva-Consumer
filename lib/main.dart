import 'package:flutter/material.dart';
// import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/introScreen.dart';
import 'package:mvp/screens/products.dart';

void main() {
  runApp(SevaApp());
}

class SevaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductScreen()
    );
  }
}