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

class CartUtilityModel {
  StoreProduct product;
  double price;
  double quantity;
  int index;
  bool addNew;
  CartUtilityModel(
      {@required this.product,
      @required this.price,
      @required this.quantity,
      @required this.index,
      @required this.addNew});
}

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

  // Remove item or quantity
  void removeFromNewCart(StoreProduct item, double p, double q, int index) {
    bool remove = false;
    // check if items exist in cart
    if (_cartItems.length > 0) {
      // check if product exist in cart
      _cartItems.forEach((cartitem) {
        if (cartitem.id == item.id) {
          // check for total Price of that item
          // just remove the desired quantity
          cartitem.details.forEach((element) {
            if ((element.quantity.allowedQuantities[index].qty - 1) >= 0) {
              element.quantity.allowedQuantities[index].qty -= 1;
              cartitem.totalPrice -= p;
              cartitem.totalQuantity -= q;
              if (cartitem.totalPrice == 0) {
                // remove from cart
                remove = true;
                return;
              }
            }
          });

          return;
        }
      });
    }
    if (remove) {
      item.details.forEach((element) {
        element.quantity.allowedQuantities[index].qty -= 1;
      });
      item.totalPrice -= p;
      item.totalQuantity -= q;
      int i = _cartItems.indexOf(item);
      if (i >= 0) {
        _cartItems.removeAt(i);
      }
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
      item.details.forEach((element) {
        element.quantity.allowedQuantities.forEach((element) {
          element.qty = 0;
        });
      });

      item.totalPrice = 0;
      item.totalQuantity = 0;
      int i = _cartItems.indexOf(item);
      _cartItems.removeAt(i);
    }
    notifyListeners();
  }

  // Clear the cart
  void clearCart() {
    if (_cartItems.length > 0) {
      _cartItems.clear();
    }
    notifyListeners();
  }

  ///****************** NEW CODE ************* */

  void addToCart(
      {@required StoreProduct item,
      @required double price,
      @required double quantity,
      @required int index}) {
    CartUtilityModel cm = CartUtilityModel(
        product: item,
        price: price,
        quantity: quantity,
        index: index,
        addNew: true);
    // check the length of cart items
    switch (_cartItems.length) {
      // no items in cart
      case 0:
        add(cm);
        break;
      // there are items in cart
      default:
        StoreProduct p =
            _cartItems.singleWhere((i) => i.id == item.id, orElse: () => null);
        // case 1 when passed item doesn't exist in cart
        if (p == null) {
          add(cm);
        }

        // case 2 when passed item exist in cart
        else {
          cm.product = p;
          cm.addNew = false;
          add(cm);
        }
    }
    notifyListeners();
  }

/****************** NEW CODE ************* */

  /// UTILITY FUNCTIONS
  void add(CartUtilityModel i) {
    i.addNew
        ? i.product.totalQuantity = i.quantity
        : i.product.totalQuantity += i.quantity;
    i.addNew ? i.product.totalPrice = i.price : i.product.totalPrice += i.price;
    i.product.details[0].quantity.allowedQuantities[i.index].qty++;
    if (i.addNew) _cartItems.add(i.product);
  }
}
