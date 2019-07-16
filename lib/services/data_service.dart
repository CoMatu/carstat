import 'dart:async';

import 'package:carstat/models/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final userId = 'EqYUUYmsi0RdG32DEYTPJNyeDVn1'; //TODO получать ID пользователя динамически
  String docId;

  CollectionReference fs = Firestore.instance.collection('users');

  Future<DocumentSnapshot> checkUsersDoc(String id) async {
    var docIsExists = await fs.document(id).get();
    return docIsExists;
  }

  getData() async {
    Future<QuerySnapshot> _userDoc = fs
        .where('userId', isEqualTo: userId)
        .getDocuments();

    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
//      print('document ID: ' + docId);
    });

    return fs.document(docId).collection('cars').getDocuments();
  }

  Future<void> addCar(Car car) async {
    var data = {
    'carVin': car.carVin,
    'carModel': car.carModel,
    'carName': car.carName,
    'carMark': car.carMark,
    'carYear': car.carYear,
    'carMileage': car.carMileage
    };
    fs.document(userId).collection('cars').document().setData(data);
  }

}