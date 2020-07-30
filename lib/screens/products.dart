import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/screens/common/customProductCard.dart';
import 'package:mvp/screens/common/productCard.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
              // Text("Vegetables"),
              RaisedButton(child: Text('Attention')),
              RaisedButton(child: Text('Fruits')),
              RaisedButton(child: Text('Daily Essentials')),
            ],
          ),
          SizedBox(
            height: 30,
          ),
         
              Expanded(child: ProductCardNew())

        ],
      )
      ),
    );
  }
}
