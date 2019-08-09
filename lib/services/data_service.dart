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
    var docRef = fs.document(docId).collection('cars').document();
    String _id = docRef.documentID;
    var data = {
      'carVin': car.carVin,
      'carModel': car.carModel,
      'carName': car.carName,
      'carMark': car.carMark,
      'carYear': car.carYear,
      'carMileage': car.carMileage,
      'carId': _id
    };
    fs.document(docId).collection('cars').document(_id).setData(data);
  }

  Future<void> updateCar(String carId, String parameter, value) async {
    await getData();
    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .updateData({parameter: value});
  }

  Future<void> deleteCar(String carId) async {
    await getData();
    fs.document(docId).collection('cars').document(carId).delete();
  }

  Future<void> addEntry(Entry entry, String carId) async {
    await getData();
    var entryRef = fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('entries')
        .document();

    var entryData = {
      'entryName': entry.entryName,
      'entryDateLimit': entry.entryDateLimit,
      'entryMileageLimit': entry.entryMileageLimit,
      'entryChange': entry.forChange,
      'entryId': entryRef.documentID
    };

    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('entries')
        .document(entryRef.documentID)
        .setData(entryData);

//        .setData(entryData);
  }

  Future<List<Entry>> getEntries(String carId) async {
    String _userId = await _firebaseAuth.currentUser();
    List<Entry> _entriesList = [];

    Future<QuerySnapshot> _userDoc =
        fs.where('userId', isEqualTo: _userId).getDocuments();
    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
    });

    Future<QuerySnapshot> _carEntries = fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('entries')
        .getDocuments();

    await _carEntries.then((res) {
      for (int i = 0; i < res.documents.length; i++) {
        var entry = Entry();
        entry.entryName = res.documents[i].data['entryName'];
        entry.entryMileageLimit = res.documents[i].data['entryMileageLimit'];
        entry.entryDateLimit = res.documents[i].data['entryDateLimit'];
        entry.forChange = res.documents[i].data['forChange'];
        entry.entryId = res.documents[i].data['entryId'];

        _entriesList.add(entry);
      }
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
      'entryId': operation.entryId
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

  Future<List<Operation>> getEntryOperations(Entry entry, String carId) async {
    String _userId = await _firebaseAuth.currentUser();
    List<Operation> _operations = [];
    Future<QuerySnapshot> _userDoc =
        fs.where('userId', isEqualTo: _userId).getDocuments();
    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
    });
    Future<QuerySnapshot> _entryOperations = fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('entries')
        .document(entry.entryId)
        .collection('operations')
        .getDocuments();

    await _entryOperations.then((val) {
      var _operation = Operation();
      for (int i = 0; i < val.documents.length; i++) {
        _operation.entryId = entry.entryId;
        _operation.operationNote = val.documents[i].data['operationNote'];
        _operation.operationDate = val.documents[i].data['operationDate'].toDate();
        _operation.operationMileage = val.documents[i].data['operationMileage'];
        _operation.operationPartName =
            val.documents[i].data['operationPartName'];
        _operations.add(_operation);
      }
    });
    return _operations;
  }
}
