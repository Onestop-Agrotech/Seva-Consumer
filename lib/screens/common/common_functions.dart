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

class helperFunctions {
  static void helper(
      int index, NewCartModel newCart, bool addToCart, StoreProduct prod) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc

    if (prod.details[0].quantity.allowedQuantities[index].metric == "Kg") {
      q = 1;
      p = double.parse("${prod.details[0].price}");
    }
    // For Gms && ML
    else if (prod.details[0].quantity.allowedQuantities[index].metric ==
            "Gms" ||
        prod.details[0].quantity.allowedQuantities[index].metric == "ML") {
      q = (prod.details[0].quantity.allowedQuantities[index].value / 1000.0);
      p = (prod.details[0].quantity.allowedQuantities[index].value / 1000.0) *
          prod.details[0].price;
    }
    // For Pc, Pack, Kgs & Ltr
    else if (prod.details[0].quantity.allowedQuantities[index].metric == "Pc" ||
        prod.details[0].quantity.allowedQuantities[index].metric == "Kgs" ||
        prod.details[0].quantity.allowedQuantities[index].metric == "Ltr" ||
        prod.details[0].quantity.allowedQuantities[index].metric == "Pack") {
      q = double.parse(
          "${prod.details[0].quantity.allowedQuantities[index].value}");
      p = prod.details[0].price * q;
    }

    addToCart
        ? newCart.addToCart(prod, index, p, q)
        : newCart.removeFromCart(prod, index, p, q);
  }
}
