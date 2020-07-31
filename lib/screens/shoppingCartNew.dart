import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/productCard.dart';

class ShoppingCartNew extends StatefulWidget {
  @override
  _ShoppingCartNewState createState() => _ShoppingCartNewState();
}

class _ShoppingCartNewState extends State<ShoppingCartNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          color: Colors.black,
          iconSize: 40.0,
          onPressed: () {},
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("My Shopping Cart",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 25,
                fontWeight: FontWeight.w600)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Expanded(child: ProductCardNew(shopping: true,))
        ],
      ),
    );
  }
}
