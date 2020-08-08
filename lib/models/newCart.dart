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

  // Add item accordingly
  void addToNewCart(StoreProduct item, double p, double q, int index) {
    bool add = false;
    if (_cartItems.length > 0) {
      // check if item already exists
      _cartItems.forEach((cartItem) {
        if (item.id == cartItem.id) {
          // already exists in cart- so add new quantity and new price
          cartItem.totalQuantity += q;
          cartItem.totalPrice += p;
          cartItem.quantity.allowedQuantities[index].qty += 1;
          return;
        } else {
          // doesn't exist in cart so add as new
          add = true;
          return;
        }
      });
      if (add) {
        item.totalQuantity = q;
        item.totalPrice = p;
        item.quantity.allowedQuantities[index].qty += 1;
        _cartItems.add(item);
      }
    } else {
      // add to cart when cart length is 0
      item.totalQuantity = q;
      item.totalPrice = p;
      item.quantity.allowedQuantities[index].qty += 1;
      _cartItems.add(item);
    }
    notifyListeners();
  }

  // Remove item or quantity
  void removeFromNewCart(StoreProduct item, double p, double q, int index) {
    bool remove = false;
    // check if items exist in cart
    if (_cartItems.length > 0) {
      // check if product exist in cart
      _cartItems.forEach((e) {
        if (e.id == item.id) {
          // check for total Price of that item
          double pDiff = e.totalPrice - p;
          if (pDiff == 0) {
            // remove from cart
            remove = true;
            return;
          } else {
            // just remove the desired quantity
            if ((e.quantity.allowedQuantities[index].qty - 1) >= 0) {
              e.quantity.allowedQuantities[index].qty -= 1;
              e.totalPrice -= p;
              e.totalQuantity -= q;
            }
            return;
          }
        }
      });
    }
    if (remove) {
      item.quantity.allowedQuantities[index].qty -= 1;
      item.totalPrice -= p;
      item.totalQuantity -= q;
      int i = _cartItems.indexOf(item);
      _cartItems.removeAt(i);
    }
    notifyListeners();
  }

  // Remove item from cart completely
  void removeItemFromNewCart(StoreProduct item) {
    bool remove = false;
    if (_cartItems.length > 0) {
      _cartItems.forEach((element) {
        if (element.id == item.id) {
          remove = true;
          return;
        }
      });
    }
    if (remove) {
      item.quantity.allowedQuantities.forEach((element) {
        element.qty = 0;
      });
      item.totalPrice = 0;
      item.totalQuantity = 0;
      int i = _cartItems.indexOf(item);
      _cartItems.removeAt(i);
    }
    notifyListeners();
  }
}
