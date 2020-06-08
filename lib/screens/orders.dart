import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

import 'common/topText.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: ThemeColoursSeva().black,
                size: 40.0,
              ),
              onPressed: () {
                // go to store list
                 Navigator.pushReplacementNamed(context, '/stores');
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TopText(txt: 'My Orders'),
          centerTitle: true,
        ),
      ),
    );
  }
}