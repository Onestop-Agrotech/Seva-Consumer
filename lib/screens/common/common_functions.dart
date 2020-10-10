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
      StoreProduct product, String value) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc

    for (var i in product.details[0].quantity.allowedQuantities) {
      if (i.metric.contains(value)) {
        q = double.parse("${i.value}" * 1);
        p = q * double.parse("${product.details[0].price}");
        break;
      } else {
        q = 1 * (i.value) / 1000.0;
        p = q * double.parse("${product.details[0].price}");
      }
    }

    // if (product.details[0].quantity.allowedQuantities[index].metric == "Kg") {
    //   q = 1;
    //   p = double.parse("${product.details[0].price}");
    // }
    // // For Gms && ML
    // else if (product.details[0].quantity.allowedQuantities[index].metric ==
    //         "Gms" ||
    //     product.details[0].quantity.allowedQuantities[index].metric == "ML") {
    //   q = (product.details[0].quantity.allowedQuantities[index].value / 1000.0);
    //   p = (product.details[0].quantity.allowedQuantities[index].value /
    //           1000.0) *
    //       product.details[0].price;
    // }
    // For Pc, Pack, Kgs & Ltr
    // else if (product.details[0].quantity.allowedQuantities[index].metric ==
    //         "Pc" ||
    //     product.details[0].quantity.allowedQuantities[index].metric == "Kgs" ||
    //     product.details[0].quantity.allowedQuantities[index].metric == "Ltr" ||
    //     product.details[0].quantity.allowedQuantities[index].metric == "Pack") {
    //   q = double.parse(
    //       "${product.details[0].quantity.allowedQuantities[index].value}");
    //   p = product.details[0].price * q;
    // }

    //
    addToCart
        ? newCart.addToCart(item: product, index: index, price: p, quantity: q)
        : newCart.removeFromCart(
            item: product, index: index, price: p, quantity: q);
  }
}
