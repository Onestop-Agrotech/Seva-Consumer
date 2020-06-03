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
    var username ='rahul';
    q = await Firestore.instance.collection('$username').getDocuments();
    docs = q.documents;
    return docs;
  }

  // void fillCart() async {
  //   String username = 'rahul';
  //   Firestore.instance.collection('$username').getDocuments().then((docs) {
  //     if (docs.documents.length > 0) {
  //       for (var i = 0; i < docs.documents.length; i++) {
  //         StoreProduct ob = new StoreProduct();
  //         ob.name = docs.documents[i].data['name'];
  //         ob.pricePerQuantity = docs.documents[i].data['pricePerQuantity'];
  //         ob.uniqueId = docs.documents[i].data['uniqueId'];
  //         ob.id = docs.documents[i].data['id'];
  //         ob.type = docs.documents[i].data['type'];
  //         ob.totalPrice = docs.documents[i].data['price'];
  //         ob.totalQuantity = docs.documents[i].data['quantity'];
  //         _cartItems.add(ob);
  //       }
  //       print(docs.documents.length);
  //       notifyListeners();
  //     }
      
  //   });
  // }

  void firstTimeAddition() async {
    if (_cartItems.length == 0) {
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
  void addItem(StoreProduct i) {
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
