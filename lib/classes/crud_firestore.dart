import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/models/storeProducts.dart';

// This class helps to interact with the Firestore Real time DB
// Uses all the CRUD operations 
class FirestoreCRUD {

  // Get all documents from Firestore
  // currently just printing everything
  getDocsFromFirestore(){
    String username = 'rahul';
    Firestore.instance
      .collection('$username')
      .getDocuments()
      .then((docs) { return docs;});
  }

  // Add document to firestore
  void addToFirestore(StoreProduct obj, String quantity, String price){
    String username = 'rahul';
    Firestore.instance.collection('$username').document('p-${obj.uniqueId}').setData({
      'product': obj.name,
      'quantity': quantity,
      'price': price,
      'pricePerQuantity': obj.pricePerQuantity
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
      'product': obj.name,
      'quantity': newq,
      'pricePerKg': newp,
      'pricePerQuantity': obj.pricePerQuantity
    });
  }

  // delete documents
  void deleteDocuments() {
    String username = 'rahul';
    Firestore.instance.collection('$username').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
      print('deleted from firestore');
    });
  }
}