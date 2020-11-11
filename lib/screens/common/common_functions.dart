// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.2
// Date-{02-10-2020}
///
/// @fileoverview common functions file : common functions used at multiple
///  files.
///

import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/productsNew/newUI.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class HelperFunctions {
  static void helper(int index, NewCartModel newCart, bool addToCart,
      StoreProduct product, String mainUnit, int value, String clickedUnit) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc

    for (var i in product.details[0].quantity.allowedQuantities) {
      if (i.metric == clickedUnit &&
          !clickedUnit.contains(mainUnit) &&
          i.value == value) {
        q = 1 * (i.value) / 1000.0;
        p = q * double.parse("${product.details[0].price}");
        break;
      } else if (i.metric.contains(clickedUnit) &&
          clickedUnit.contains(mainUnit)) {
        q = double.parse("${i.value}" * 1);
        p = q * double.parse("${product.details[0].price}");
        break;
      }
    }

    addToCart
        ? newCart.addToCart(item: product, index: index, price: p, quantity: q)
        : newCart.removeFromCart(
            item: product, index: index, price: p, quantity: q);
  }

  // Common text widget for both bestsellers and categories
  static Widget commonText(height, leftText, rightText, context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 10.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leftText,
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontWeight: FontWeight.w900,
                fontSize: 1.9 * SizeConfig.textMultiplier),
          ),
          GestureDetector(
            onTap: () {
              if (leftText == "Categories")
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return ProductsUINew(tagFromMain: 0);
                }));
            },
            child: Text(
              rightText,
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
