import 'dart:async';

import 'package:carstat/models/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final userId =
      'EqYUUYmsi0RdG32DEYTPJNyeDVn1'; //TODO получать ID пользователя динамически
  String docId;

  CollectionReference fs = Firestore.instance.collection('users');

  Future<QuerySnapshot> checkUserDocs(String id) async {
    return fs.where('userId', isEqualTo: userId).getDocuments().then((res) {
      if(res.documents.length == 0)
        fs.add({'userId': userId});
      return res;
    });
  }

  getData() async {
    Future<QuerySnapshot> _userDoc =
        fs.where('userId', isEqualTo: userId).getDocuments();

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
}
