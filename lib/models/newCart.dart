// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview new cart model : models the cart with database.
///

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:mvp/models/storeProducts.dart';

class NewCartModel extends ChangeNotifier {
  // private to the model only - non-readable var
  List<StoreProduct> _cartItems = [];

  // Non-mutable list - readonly var
  UnmodifiableListView<StoreProduct> get items =>
      UnmodifiableListView(_cartItems);

  // get total price of cart
  double getCartTotalPrice() {
    double sum = 0;
    if (_cartItems.length > 0) {
      _cartItems.forEach((element) {
        sum += element.totalPrice;
      });
    }
    return sum;
  }

  // get total Items in cart
  int get totalItems => _cartItems.length;

  // Clear the cart
  void clearCart() {
    if (_cartItems.length > 0) {
      _cartItems.clear();
    }
    notifyListeners();
  }

  ///****************** NEW CODE ************* */

  void addToCart(StoreProduct item, int i, double p, double q) {
    if (_cartItems.length == 0) {
      addNew(item, p, q, i, true);
    } else if (_cartItems.length > 0) {
      StoreProduct product =
          _cartItems.singleWhere((z) => z.id == item.id, orElse: () => null);
      if (product != null) {
        // item exists
        addNew(item, p, q, i, false);
      } else if (product == null) {
        // item does not exist
        addNew(item, p, q, i, true);
      }
    }
  }

  void addNew(StoreProduct item, double p, double q, int i, bool n) {
    item.totalPrice += p;
    item.totalQuantity += q;
    item.details[0].quantity.allowedQuantities[i].qty++;
    if (n) _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(StoreProduct item, int i, double p, double q) {
    if (_cartItems.length > 0) {
      StoreProduct product =
          _cartItems.singleWhere((z) => z.id == item.id, orElse: () => null);
      if (product != null) {
        subtract(item, p, q, i);
      }
    }
  }

  void subtract(StoreProduct item, double p, double q, int i) {
    if (item.totalQuantity - q >= 0 &&
        item.totalPrice - p >= 0 &&
        item.details[0].quantity.allowedQuantities[i].qty - 1 >= 0) {
      item.totalPrice -= p;
      item.totalQuantity -= q;
      item.details[0].quantity.allowedQuantities[i].qty--;
      if (item.totalPrice == 0 &&
          item.totalQuantity == 0 &&
          item.details[0].quantity.allowedQuantities[i].qty == 0) {
        _cartItems.removeWhere((z) => z.id == item.id);
      }
      notifyListeners();
    }
  }

  void remove(StoreProduct item) {
    if (_cartItems.length > 0) {
      _cartItems.removeWhere((n) => n.id == item.id);
      notifyListeners();
    }
  }
}
