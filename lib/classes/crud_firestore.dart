import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/models/storeProducts.dart';

// This class helps to interact with the Firestore Real time DB
// Uses all the CRUD operations
class FirestoreCRUD {
  // Add document to firestore
  void addToFirestore(StoreProduct obj) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    String url = APIService.setCartAPI + "$id";
    String body=jsonEncode(
{
      'description': obj.description,
      'userId':obj.id,
      'name':obj.name,
      'pictureURL':obj.pictureUrl,
      'productPrice':obj.totalPrice,
      'quantityMetric':obj.quantity.quantityMetric,
      'quantityValue':obj.quantity.quantityValue,
      'type':obj.type,
      'uniqueId':obj.uniqueId,
      'userPrice':obj.totalPrice,
      'userQuantity':obj.totalQuantity
      
    }

    );
    var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('something is wrong');
    }
    // Firestore.instance.collection('$id').document('p-${obj.uniqueId}').setData({
    //   'name': obj.name,
    //   'productPrice': obj.price,
    //   'userQuantity': obj.totalQuantity,
    //   'userPrice': obj.totalPrice,
    //   'quantityValue': obj.quantity.quantityValue,
    //   "quantityMetric": obj.quantity.quantityMetric,
    //   'uniqueId': obj.uniqueId,
    //   'description': obj.description,
    //   'id': obj.id,
    //   'type': obj.type,
    //   'pictureURL': obj.pictureUrl
    // });
  }

  // Delete a particular document from firestore
  void deleteFromFirestore(String uId) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    Firestore.instance.collection('$id').document('p-$uId').delete();
  }

  // Update document
  void updateDocInFirestore(String docId, int newq, int newp) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    Firestore.instance.collection('$id').document(docId).updateData({
      'userQuantity': newq,
      'userPrice': newp,
    });
  }

  // delete documents
  void deleteDocuments() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    Firestore.instance.collection('$id').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }
}
