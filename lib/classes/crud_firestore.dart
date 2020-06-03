import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/models/storeProducts.dart';

// This class helps to interact with the Firestore Real time DB
// Uses all the CRUD operations 
class FirestoreCRUD {

  // Add document to firestore
  void addToFirestore(StoreProduct obj, int quantity, int price){
    String username = 'rahul';
    Firestore.instance.collection('$username').document('p-${obj.uniqueId}').setData({
      'name': obj.name,
      'quantity': quantity,
      'price': price,
      'pricePerQuantity': obj.pricePerQuantity,
      'uniqueId': obj.uniqueId,
      'id':obj.id,
      'type':obj.type,
    });
  }

  // Delete a particular document from firestore
  void deleteFromFirestore(String uId){
    String username = 'rahul';
    Firestore.instance.collection('$username').document('p-$uId').delete();
  }

  // Update document
  void updateDocInFirestore(String docId, StoreProduct obj, String newq, String newp) {
    String username = 'rahul';
    Firestore.instance.collection('$username').document(docId).updateData({
      'quantity': newq,
      'pricePerKg': newp,
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