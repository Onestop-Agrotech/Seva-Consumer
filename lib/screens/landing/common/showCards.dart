import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class ShowCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // fallback height
      height: height * 0.22,
      width: width * 0.4,
      decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColoursSeva().pallete3,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Tomato - Hybrid",
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: ThemeColoursSeva().pallete2,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
          Container(
            height: height * 0.1,
            child: CachedNetworkImage(
              imageUrl:
                  "https://storepictures.theonestop.co.in/products/apple.jpg",
              placeholder: (context, url) =>
                  Container(height: 50.0, child: Text("Loading...")),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Text(
            "Rs 250 - 1 Kg",
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: ThemeColoursSeva().pallete2,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
