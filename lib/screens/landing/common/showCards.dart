// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview ShowCards Widget : .
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/AnimatedCard/modalContainer.dart';
import 'package:mvp/screens/products/products.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class ShowCards extends StatefulWidget {
  final StoreProduct sp;
  final Details dt;
  final bool store;
  final int index;
  ShowCards({this.sp, this.store, @required this.index, this.dt});

  @override
  _ShowCardsState createState() => _ShowCardsState();
}

class _ShowCardsState extends State<ShowCards> {
  void onClickProduct() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
              child: AddItemModal(
            product: widget.sp,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!this.widget.store)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Products(type: this.widget.index)),
          );
        else {
          // open the modal container
          // this.widget.sp.details.forEach((element) {
          //   if (!element.outOfStock) onClickProduct();
          // });
          if (!this.widget.dt.outOfStock) onClickProduct();
        }
      },
      child: Container(
        // fallback height
        height: height * 0.22,
        width: width * 0.4,
        decoration: BoxDecoration(
            border: !this.widget.store
                ? Border.all(
                    color: ThemeColoursSeva().pallete3,
                    width: 1.5,
                  )
                : Border.all(
                    color: !this.widget.dt.outOfStock
                        ? ThemeColoursSeva().pallete3
                        : ThemeColoursSeva().grey,
                    width: !this.widget.dt.outOfStock ? 1.5 : 0.2,
                  ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            widget.store
                ? Text(
                    "${widget.sp.name}",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: !this.widget.dt.outOfStock
                            ? ThemeColoursSeva().pallete1
                            : ThemeColoursSeva().grey,
                        fontSize: 3.4 * SizeConfig.widthMultiplier,
                        fontWeight: FontWeight.w700),
                  )
                : SizedBox.shrink(),
            Container(
              height: height * 0.1,
              child: CachedNetworkImage(
                imageUrl: widget.sp.pictureURL,
                placeholder: (context, url) =>
                    Container(height: 50.0, child: Text("Loading...")),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            widget.store
                ? Text(
                    !this.widget.dt.outOfStock
                        ? "Rs ${widget.dt.price} - ${widget.dt.quantity.quantityValue} ${widget.dt.quantity.quantityMetric}"
                        : "Out of Stock",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: !this.widget.dt.outOfStock
                            ? ThemeColoursSeva().pallete1
                            : ThemeColoursSeva().grey,
                        fontSize: 3.4 * SizeConfig.widthMultiplier,
                        fontWeight: FontWeight.w700),
                  )
                : Text(
                    "${widget.sp.name}",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontSize: 3.4 * SizeConfig.widthMultiplier,
                        fontWeight: FontWeight.w700),
                  )
          ],
        ),
      ),
    );
  }
}
