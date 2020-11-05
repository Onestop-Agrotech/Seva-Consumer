// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.0
// Date-{27-09-2020}

///
/// @fileoverview ShowCards Widget : .
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/category.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/productsNew/details.dart';
import 'package:mvp/screens/productsNew/newUI.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class ShowCards extends StatefulWidget {
  final StoreProduct sp;
  final Category cat;
  final bool store;
  final int index;
  ShowCards({this.sp, @required this.store, @required this.index, this.cat});

  @override
  _ShowCardsState createState() => _ShowCardsState();
}

class _ShowCardsState extends State<ShowCards> {
  /* click function for the best seller card on main
  landing screen will redirect to [details.dart] screen */
  void onClickProduct() {
    if (!widget.sp.details[0].outOfStock) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ProductDetails(
          p: widget.sp,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!this.widget.store)
          Navigator.of(context)
              .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
            return ProductsUINew(tagFromMain: this.widget.index);
          }));
        else {
          // open the modal container
          if (!this.widget.sp.details[0].outOfStock) onClickProduct();
        }
      },
      child: Container(
        // fallback height
        height: height * 0.12,
        width: width * 0.24,
        decoration: BoxDecoration(
            border: !this.widget.store
                ? Border.all(
                    color: ThemeColoursSeva().pallete3,
                    width: 0.7,
                  )
                : Border.all(
                    color: !this.widget.sp.details[0].outOfStock
                        ? ThemeColoursSeva().pallete3
                        : ThemeColoursSeva().grey,
                    width: !this.widget.sp.details[0].outOfStock ? 0.7 : 0.2,
                  ),
            borderRadius: BorderRadius.circular(2.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Hero animation on clicking any bestseller card
            Hero(
              tag: this.widget.store ? widget.sp.name : this.widget.cat.name,
              transitionOnUserGestures: true,
              child: Container(
                height: height * 0.06,
                child: CachedNetworkImage(
                  imageUrl: this.widget.store
                      ? widget.sp.pictureURL
                      : this.widget.cat.imgURL,
                  placeholder: (context, url) =>
                      Container(height: 20.0, child: Text("")),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Text(
              !this.widget.store ? "${widget.cat.name}" : "${widget.sp.name}",
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ThemeColoursSeva().pallete1,
                  fontSize: 3.1 * SizeConfig.widthMultiplier,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
