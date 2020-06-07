import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  ProductCard({this.productName = 'Product Name'});

  _qtyBuilder() {
    return Container(
      width: 105.0,
      height: 30.0,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColoursSeva().black, width: 0.2),
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove,
            ),
            onPressed: () {},
            iconSize: 15.0,
          ),
          Text('0'),
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {},
            iconSize: 15.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 250.0,
      width: width * 0.43,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // image
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5.0),
            child: CachedNetworkImage(
              imageUrl: "http://via.placeholder.com/160x120",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Text(
              productName,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: ThemeColoursSeva().black),
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Text(
              "Local",
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: ThemeColoursSeva().grey),
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Rs 200",
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: ThemeColoursSeva().black),
                ),
                Text(
                  "1 kg",
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: ThemeColoursSeva().black),
                )
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[_qtyBuilder(), Text("Qty")],
              );
            },
          ),
        ],
      ),
    );
  }
}
