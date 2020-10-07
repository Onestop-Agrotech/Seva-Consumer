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
import 'package:mvp/classes/cartItems_box.dart';
import 'package:mvp/models/storeProducts.dart';

class NewCartModel extends ChangeNotifier {
  CIBox _ciBox;

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
  void clearCart() async {
    if (_cartItems.length > 0) {
      _cartItems.clear();
      _ciBox = await CIBox.getCIBoxInstance();
      await _ciBox.clearBox();
    }
    notifyListeners();
  }

  ///****************** NEW CODE ************* */

  // void addToCart(StoreProduct item, int i, double p, double q) {
  //   if (_cartItems.length == 0) {
  //     addNew(item, p, q, i, true);
  //   } else if (_cartItems.length > 0) {
  //     StoreProduct product =
  //         _cartItems.singleWhere((z) => z.id == item.id, orElse: () => null);
  //     if (product != null) {
  //       // item exists
  //       addNew(item, p, q, i, false);
  //     } else if (product == null) {
  //       // item does not exist
  //       addNew(item, p, q, i, true);
  //     }
  //   }
  // }

  void addNew(StoreProduct item, double p, double q, int i, bool n) async {
    // item.totalPrice += p;
    // item.totalQuantity += q;
    // item.details[0].quantity.allowedQuantities[i].qty++;
    // if (n) _cartItems.add(item);
    // notifyListeners();
    // _ciBox = await CIBox.getCIBoxInstance();
    // if (n) await _ciBox.addToCIBox(item);
    // _ciBox.editItemInCIBox(
    //     sp: item,
    //     totalPrice: item.totalPrice + p,
    //     totalQuantity: item.totalQuantity + q,
    //     index: i,
    //     qty: item.details[0].quantity.allowedQuantities[i].qty++);
    // List<StoreProduct> sp = await _ciBox.getAllItems();
    // sp.forEach((i) {
    //   _cartItems.add(i);
    // });
    // notifyListeners();
  }

  // void removeFromCart(StoreProduct item, int i, double p, double q) {
  //   if (_cartItems.length > 0) {
  //     StoreProduct product =
  //         _cartItems.singleWhere((z) => z.id == item.id, orElse: () => null);
  //     if (product != null) {
  //       subtract(item, p, q, i);
  //     }
  //   }
  // }

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

  void remove(StoreProduct item) async {
    if (_cartItems.length > 0) {
      _cartItems.removeWhere((n) => n.id == item.id);
      _ciBox = await CIBox.getCIBoxInstance();
      await _ciBox.clearBox();
      _cartItems.clear();
      notifyListeners();
    }
  }

  /// Version 0.5.2+1
  ///
  Future<void> addToCart(
      {StoreProduct item, int index, double price, double quantity}) async {
    _ciBox = await CIBox.getCIBoxInstance();
    if (_cartItems.length == 0) {
      // add to cart as new
      item.totalPrice = price;
      item.totalQuantity = quantity;
      item.details[0].quantity.allowedQuantities[index].qty += 1;
      _ciBox.addToCIBox(item);
      cartItemsRefill(_ciBox);
    } else {
      // items exist in cart
      _cartItems.clear();
      _ciBox.addStuffToItem(
        sp: item,
        totalQuantity: quantity,
        totalPrice: price,
        index: index,
      );
      cartItemsRefill(_ciBox);
    }
    notifyListeners();
  }

  /// Version 0.5.2+1
  ///
  Future<void> removeFromCart(
      {StoreProduct item, int index, double price, double quantity}) async {
    _ciBox = await CIBox.getCIBoxInstance();
    if (_cartItems.length > 0) {
      /// find the item
      ///
      StoreProduct sp =
          _cartItems.singleWhere((z) => z.id == item.id, orElse: () => null);
      if (sp != null) {
        // item exists in cart
        if (sp.totalPrice - price == 0) {
          // remove from Hive & cart completely
          await _ciBox.removeFromCIBox(item);
          _cartItems.removeWhere((i) => i.id == item.id);
        } else {
          // just remove the quantity
          _cartItems.clear();
          _ciBox.removeStuffFromItem(
              sp: item,
              totalPrice: price,
              totalQuantity: quantity,
              index: index,
              qty: item.details[0].quantity.allowedQuantities[index].qty);
          cartItemsRefill(_ciBox);
        }
      }
      printCartItems();
    }
    notifyListeners();
  }

  void cartItemsRefill(CIBox cb) {
    List<StoreProduct> l = cb.getAllItems();
    l.forEach((i) {
      _cartItems.add(i);
    });
  }

  void printCartItems() {
    _cartItems.forEach((StoreProduct a) {
      print("${a.name}");
      a.details[0].quantity.allowedQuantities.forEach((z) {
        print("${z.qty} - ${z.value} - ${z.metric}");
      });
    });
  }

  void printCBItems(CIBox cb) {
    var l = cb.getAllItems();
    l.forEach((StoreProduct a) {
      print("${a.name}");
      a.details[0].quantity.allowedQuantities.forEach((z) {
        print("${z.qty} - ${z.value} - ${z.metric}");
      });
    });
  }
}
