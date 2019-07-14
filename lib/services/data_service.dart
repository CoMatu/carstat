import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final userId = 'EqYUUYmsi0RdG32DEYTPJNyeDVn1'; //TODO получать ID пользователя динамически
  String docId;

  CollectionReference fs = Firestore.instance.collection('users');
  DocumentReference _documentReference;

  addData(List data) async {}

  getData() async {
    Future<QuerySnapshot> _userDoc = fs
        .where('userId', isEqualTo: userId)
        .getDocuments();

    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
      print('document ID: ' + docId);
    });

    return fs.document(docId).collection('cars').getDocuments();
  }

}