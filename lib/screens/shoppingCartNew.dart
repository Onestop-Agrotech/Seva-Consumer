import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/constants/themeColours.dart';

import 'common/AnimatedCard/animatedCard.dart';

class ShoppingCartNew extends StatefulWidget {
  @override
  _ShoppingCartNewState createState() => _ShoppingCartNewState();
}

class _ShoppingCartNewState extends State<ShoppingCartNew> {
  _showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Summary"),
                // text and promo btn
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 30.0),
                    RaisedButton(onPressed: () {}, child: Text("Apply Promo"))
                  ],
                ),
                // slide to pay btn
                RaisedButton(onPressed: () {}, child: Text("Slide to pay"))
              ],
            );
          });
        });
  }

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
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: 3,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 0.0,
              itemBuilder: (BuildContext categories, int index) {
                return Row(
                  children: <Widget>[
                    SizedBox(width: 12.0),
                    Expanded(child: AnimatedCard(shopping: true)),
                    SizedBox(width: 9.0)
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          // open the bottomsheet
          _showModal();
        },
        child: Text(
          "Proceed",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        color: ThemeColoursSeva().dkGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
