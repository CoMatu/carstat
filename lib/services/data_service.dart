import 'dart:async';
import 'package:carstat/models/entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carstat/models/car.dart';
import 'package:carstat/services/auth_service.dart';

class DataService {
  String docId;
  AuthService _firebaseAuth = AuthService();

  CollectionReference fs = Firestore.instance.collection('users');

  Future<QuerySnapshot> checkUserDocs(String id) async {
    return fs.where('userId', isEqualTo: id).getDocuments().then((res) {
      if(res.documents.length == 0)
        fs.add({'userId': id});
      return res;
    });
  }

  getData() async {
    String _userId = await _firebaseAuth.currentUser();

    Future<QuerySnapshot> _userDoc =
        fs.where('userId', isEqualTo: _userId).getDocuments();

    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
      print('document ID: ' + docId);
    });

    return fs.document(docId).collection('cars').getDocuments();
  }

  Future<void> addCar(Car car) async {
    await getData();
    var data = {
      'carVin': car.carVin,
      'carModel': car.carModel,
      'carName': car.carName,
      'carMark': car.carMark,
      'carYear': car.carYear,
      'carMileage': car.carMileage
    };
    fs.document(docId).collection('cars').document().setData(data);
  }

  Future<void> addEntry(Entry entry) async {
    var entryData = {
    'entryName': entry.entryName,
    'entryDate': entry.entryDate,
    'entryDateLimit': entry.entryDateLimit,
    'entryMileage': entry.entryMileage,
    'entryMileageLimit': entry.entryMileageLimit,
    'entryPartName': entry.entryPartName,
    'entryNote': entry.entryNote
    };
  }
}
