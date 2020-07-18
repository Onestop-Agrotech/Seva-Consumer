import 'dart:convert';
import 'package:http/http.dart' as http;
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
    String token = await p.getToken();
    String url = APIService.setCartAPI;
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String body = jsonEncode({
      'description': obj.description,
      'userId': id,
      'name': obj.name,
      'pictureURL': obj.pictureUrl,
      'productPrice': obj.price,
      'quantityMetric': obj.quantity.quantityMetric,
      'quantityValue': obj.quantity.quantityValue,
      'type': obj.type,
      'uniqueId': obj.uniqueId,
      'userPrice': obj.totalPrice,
      'userQuantity': obj.totalQuantity
    });
    var response = await http.post(url, body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('something is wrong');
    }
  }

  // Delete a particular document from firestore
  void deleteFromFirestore(String uId) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    String token = await p.getToken();
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.removeitemAPI;
    String body = jsonEncode({
      'userId': id,
      'uniqueId': uId,
    });
    var response = await http.post(url, body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('something is wrong');
    }
    // Firestore.instance.collection('$id').document('p-$uId').delete();
  }

  // Update document
  void updateDocInFirestore(String docId, int newq, int newp) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    String token = await p.getToken();
    String url = APIService.updatecartAPI;
    Map<String, String> requestHeaders = {'x-auth-token': token};

    String body = jsonEncode({
      'userPrice': newp,
      'userQuantity': newq,
      'uniqueId': docId,
      'userId': id
    });
    var response = await http.post(url, body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('something is wrong');
    }

    // Firestore.instance.collection('$id').document(docId).updateData({
    //   'userQuantity': newq,
    //   'userPrice': newp,
    // });
  }

  // delete documents
  void deleteDocuments() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    String token = await p.getToken();
    String url = APIService.emptycartAPI;
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String body = jsonEncode({
      'userId': id,
    });
    var response = await http.post(url, body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('something is wrong');
    }

    // Firestore.instance.collection('$id').getDocuments().then((snapshot) {
    //   for (DocumentSnapshot ds in snapshot.documents) {
    //     ds.reference.delete();
    //   }
    // });
  }
}
