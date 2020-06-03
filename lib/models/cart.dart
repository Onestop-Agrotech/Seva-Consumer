import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/classes/crud_firestore.dart';
import 'package:mvp/models/storeProducts.dart';

class CartModel extends ChangeNotifier {

  List<StoreProduct> _cartItems = [];

  UnmodifiableListView<StoreProduct> get items => UnmodifiableListView(_cartItems);

  int get listLength => _cartItems.length;
  FirestoreCRUD f = new FirestoreCRUD();

  // check for items in firestore
  checkFireStore() {
    List<DocumentSnapshot> docs = f.getDocsFromFirestore();
    return docs;
  }

  // Add item to cart
  void addItem(StoreProduct i){
    _cartItems.add(i);
    f.addToFirestore(i, "1 kg", "Rs 30");
    notifyListeners();
  }

  // Remove from cart
  void removeItem(StoreProduct i) {
    int itemIndex = _cartItems.indexOf(i);
    String uid = _cartItems[itemIndex].uniqueId;
    _cartItems.removeAt(itemIndex);
    f.deleteFromFirestore(uid);
    notifyListeners();
  }
}