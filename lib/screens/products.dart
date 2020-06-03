import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenProducts.dart';
import 'package:mvp/screens/common/customProductCard.dart';
import 'package:mvp/screens/common/topText.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController search;

  ListView _buildItems(){
    return ListView.builder(itemCount: 4, itemBuilder: (ctxt, index){
      return Text("Hello");
    });
  }

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
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 40.0, right: 20.0),
                child: TopText(txt: "Sri Laxmi Vegetables & fruits",),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 90),
              child: SearchBar(
                onItemFound: null,
                onSearch: null,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 210.0),
                child: _buildItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
