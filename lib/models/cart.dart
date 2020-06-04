import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/classes/crud_firestore.dart';
import 'package:mvp/models/storeProducts.dart';

class CartModel extends ChangeNotifier {
  List<StoreProduct> _cartItems = [];

  UnmodifiableListView<StoreProduct> get items =>
      UnmodifiableListView(_cartItems);

  int get listLength => _cartItems.length;
  FirestoreCRUD f = new FirestoreCRUD();

  // check for items in firestore
  _checkFireStore() async {
    List<DocumentSnapshot> docs;
    QuerySnapshot q;
    var username = 'rahul';
    q = await Firestore.instance.collection('$username').getDocuments();
    docs = q.documents;
    return docs;
  }

  void firstTimeAddition() async {
    if (_cartItems.length == 0) {
      // print("Added from firestore");
      var docs = await _checkFireStore();
      docs.forEach((d) {
        StoreProduct ob = new StoreProduct();
        ob.name = d.data['name'];
        ob.pricePerQuantity = d.data['pricePerQuantity'];
        ob.uniqueId = d.data['uniqueId'];
        ob.id = d.data['id'];
        ob.type = d.data['type'];
        ob.totalPrice = d.data['price'];
        ob.totalQuantity = d.data['quantity'];
        _cartItems.add(ob);
      });
      notifyListeners();
    }
  }

  // Add item to cart
  void addItem(StoreProduct i, int totalQuantity, int totalPrice) {
    // check if it exists already, then don't add
    bool matched = false;
    _cartItems.forEach((element) {
      if (element.uniqueId == i.uniqueId) {
        matched = true;
        return;
      }
    });

    if (matched == false) {
      print("added once");
      _cartItems.add(i);
      f.addToFirestore(i, totalQuantity, totalPrice);
      notifyListeners();
    }
  }

  // Remove from cart
  void removeItem(StoreProduct i) {
    int index = -1;
    _cartItems.forEach((element) {
      if (element.uniqueId == i.uniqueId) index = _cartItems.indexOf(element);
    });
    if (index != -1) {
      String uid = _cartItems[index].uniqueId;
      _cartItems.removeAt(index);
      f.deleteFromFirestore(uid);
      notifyListeners();
    }
  }

  // update quantity by 1 for an item
  void updateQtyByOne(StoreProduct i) {
    bool matched = false;
    _cartItems.forEach((item) {
      if (item.uniqueId == i.uniqueId) {
        matched = true;
        item.totalQuantity = item.totalQuantity + 1;
        f.updateDocInFirestore('p-${item.uniqueId}', item.totalQuantity, 100);
        notifyListeners();
        return;
      }
    });
    if (matched == false) {
      addItem(i, 1, 100);
    }
  }

  // update quantity by -1 for an item
  void minusQtyByOne(StoreProduct i) {
    _cartItems.forEach((item) {
      if (item.uniqueId == i.uniqueId) {
        if (item.totalQuantity != 0) {
          item.totalQuantity = item.totalQuantity - 1;
          if (item.totalQuantity != 0) {
            f.updateDocInFirestore(
                'p-${item.uniqueId}', item.totalQuantity, 100);
            notifyListeners();
          } else if (item.totalQuantity == 0) {
            removeItem(item);
          }
          return;
        }
      }
    });
  }
}
