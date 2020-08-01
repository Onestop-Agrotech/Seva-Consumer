import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/AnimatedCard/animatedCard.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
              child: Text(
            "Fresh Fruits",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 25,
                fontWeight: FontWeight.w600),
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
                  color:
                      tapped == i ? ThemeColoursSeva().dkGreen : Colors.white,
                  onPressed: () {
                    setState(() {
                      tapped = i;
                    });
                  },
                  child: Text(
                    categories[i],
                    style: TextStyle(
                        color: tapped == i
                            ? Colors.white
                            : ThemeColoursSeva().dkGreen),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          // AnimatedCard(shopping: false)

          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: categories.length,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 0.0,
              itemBuilder: (BuildContext categories, int index) {
                return Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Expanded(
                        child: AnimatedCard(shopping: false),
                      ),
                      SizedBox(width: 9.0)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
