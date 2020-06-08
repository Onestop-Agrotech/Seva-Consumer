import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/models/storeProducts.dart';

// This class helps to interact with the Firestore Real time DB
// Uses all the CRUD operations 
class FirestoreCRUD {

  // Add document to firestore
  void addToFirestore(StoreProduct obj){
    String username = 'rahul';
    Firestore.instance.collection('$username').document('p-${obj.uniqueId}').setData({
      'name': obj.name,
      'productPrice': obj.price,
      'userQuantity': obj.totalQuantity,
      'userPrice': obj.totalPrice,
      'quantityValue': obj.quantity.quantityValue,
      "quantityMetric": obj.quantity.quantityMetric,
      'uniqueId': obj.uniqueId,
      'description': obj.description,
      'id':obj.id,
      'type':obj.type,
      'pictureURL':obj.pictureUrl
    });
  }

  // Delete a particular document from firestore
  void deleteFromFirestore(String uId){
    String username = 'rahul';
    Firestore.instance.collection('$username').document('p-$uId').delete();
  }

  // Update document
  void updateDocInFirestore(String docId, int newq, int newp) {
    String username = 'rahul';
    Firestore.instance.collection('$username').document(docId).updateData({
      'userQuantity': newq,
      'userPrice': newp,
    });
  }

  // delete documents
  void deleteDocuments() {
    String username = 'rahul';
    Firestore.instance.collection('$username').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }
}