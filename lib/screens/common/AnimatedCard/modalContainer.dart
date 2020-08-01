import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class AddItemModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: MediaQuery.of(context).size.height - 300,
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "Apple - Red Delicious",
            style: TextStyle(
              color: ThemeColoursSeva().pallete2,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Rs 120 - 1 Kg",
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: ThemeColoursSeva().pallete2,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CachedNetworkImage(
                  width: 200,
                  height: 140,
                  imageUrl:
                      "https://storepictures.theonestop.co.in/products/pineapple.png"),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.,
                children: <Widget>[
                  Text(
                    "200 Gms",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: ThemeColoursSeva().pallete2,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "200 Gms",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: ThemeColoursSeva().pallete2,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "200 Gms",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: ThemeColoursSeva().pallete2,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Apples contain  no fat, sodium or cholestrol and are a good source",
            style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Item Total Price",
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              ),
              Text(
                "250",
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              )
            ],
          )
        ],
      ),
    );
  }
}
