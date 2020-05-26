import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mvp/graphics/greenProducts.dart';
import 'package:mvp/screens/common/topText.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[Text("hello")],
        ),
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintProducts(),
            child: Center(child: null),
          ),
          SafeArea(
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TopText(txt: "Products"),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
              child: SearchBar(onItemFound: null, onSearch: null,),
            ),
          ),
        ],
      ),
    );
  }
}
