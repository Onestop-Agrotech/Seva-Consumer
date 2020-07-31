import 'package:flutter/material.dart';
import 'package:mvp/screens/common/productCard.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List categories = ['Vegetables', 'Fruits', 'Daily Essentials'];
  int tapped;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
              child: Text(
            "Fresh Fruits",
            style: TextStyle(
                color: Colors.green, fontSize: 35, fontWeight: FontWeight.w600),
          )),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (int i = 0; i < categories.length; i++)
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: tapped == i ? Colors.green : Colors.white,
                  onPressed: () {
                    setState(() {
                      tapped = i;
                    });
                  },
                  child: Text(categories[i], style: TextStyle(color:tapped==i? Colors.white: Colors.black),),
                ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(child: ProductCardNew())
        ],
      )),
    );
  }
}
