// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.2
// Date-{02-10-2020}
import 'dart:ffi';

///
/// @fileoverview common functions file : common functions used at multiple
///  files.
///

import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';

class HelperFunctions {
  static void helper(int index, NewCartModel newCart, bool addToCart,
      StoreProduct product, String mainUnit, String clickedUnit) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc

    for (var i in product.details[0].quantity.allowedQuantities) {
      if (i.metric == clickedUnit && !clickedUnit.contains(mainUnit)) {
        q = 1 * (i.value) / 1000.0;
        p = q * double.parse("${product.details[0].price}");
      } else if (i.metric.contains(clickedUnit)) {
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
}
