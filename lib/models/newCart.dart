import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mvp/models/storeProducts.dart';

class NewCartModel extends ChangeNotifier {
  // private to the model only - non-readable var
  List<StoreProduct> _cartItems = [];

  // Non-mutable list - readonly var
  UnmodifiableListView<StoreProduct> get items =>
      UnmodifiableListView(_cartItems);

  // Add item accordingly
  void addToNewCart(StoreProduct item) {
    bool add = false;
    if (_cartItems.length > 0) {
      // check if item already exists
      _cartItems.forEach((cartItem) {
        if (item.id == cartItem.id) {
          // already exists in cart- so add new quantity and new price
          cartItem.totalQuantity += item.totalQuantity;
          cartItem.totalPrice += item.totalPrice;
          return;
        } else {
          // doesn't exist in cart so add as new
          add = true;
          return;
        }
      });
      if (add) _cartItems.add(item);
    } else {
      // add to cart when cart length is 0
      _cartItems.add(item);
    }
    notifyListeners();
  }

  // Remove item or quantity
  void removeFromCart(StoreProduct item) {
    bool remove = false;
    if (_cartItems.length > 0) {
      // check if item exists
      _cartItems.forEach((cartItem) {
        if (item.id == cartItem.id) {
          var diff = cartItem.totalQuantity - item.totalQuantity;
          if (diff == 0) {
            // remove from cart
            remove = true;
            return;
          } else {
            // just remove the desired quantity
            cartItem.totalQuantity -= item.totalQuantity;
            cartItem.totalPrice -= item.totalPrice;
            return;
          }
        }
      });
      if (remove) {
        // remove from cart
        int index = _cartItems.indexOf(item);
        _cartItems.removeAt(index);
      }
    }
    notifyListeners();
  }
}
