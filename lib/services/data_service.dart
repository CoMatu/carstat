import 'dart:async';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carstat/models/car.dart';
import 'package:carstat/services/auth_service.dart';

class DataService {
  String docId;
  AuthService _firebaseAuth = AuthService();

  CollectionReference fs = Firestore.instance.collection('users');

  Future<QuerySnapshot> checkUserDocs(String id) async {
    return fs.where('userId', isEqualTo: id).getDocuments().then((res) {
      if (res.documents.length == 0) fs.add({'userId': id});
      return res;
    });
  }

  getData() async {
    String _userId = await _firebaseAuth.currentUser();

    Future<QuerySnapshot> _userDoc =
        fs.where('userId', isEqualTo: _userId).getDocuments();

    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
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
    fs
        .document(docId)
        .collection('cars')
        .document()
        .setData(data);
  }

  Future<void> addEntry(Entry entry, String carId) async {
    await getData();
    var entryData = {
      'entryName': entry.entryName,
      'entryDateLimit': entry.entryDateLimit,
      'entryMileageLimit': entry.entryMileageLimit,
      'entryChange': entry.forChange
    };

    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('entries')
        .document()
        .setData(entryData);
  }

  Future<List<Entry>> getEntries(String carId) async {
    String _userId = await _firebaseAuth.currentUser();
    List<Entry> _entriesList = [];

    Future<QuerySnapshot> _userDoc = fs.where('userId', isEqualTo: _userId)
    .getDocuments();
    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
    });

    Future<QuerySnapshot> _carEntries = fs.document(docId).collection('cars').document(carId)
    .collection('entries').getDocuments();

    await _carEntries.then((res) {
      res.documents.forEach((doc) {
        var entry = Entry();
        entry.entryName = doc.data['entryName'];
        entry.entryMileageLimit = doc.data['entryMileageLimit'];
        entry.entryDateLimit = doc.data['entryDateLimit'];
        entry.forChange = doc.data['forChange'];

        _entriesList.add(entry);
      });
    });

    return _entriesList;
  }

  Future<void> addOperation(Operation operation, String carId) async {
    await getData();
    var entryId = operation.entryId;
    var operationData = {
      'operationDate': operation.operationDate,
      'operationMileage': operation.operationMileage,
      'operationPartName': operation.operationPartName,
      'operationNote': operation.operationNote,
    };

    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('entries')
        .document(entryId)
        .collection('operations')
        .document()
        .setData(operationData);
  }
}
