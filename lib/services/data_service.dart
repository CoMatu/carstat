import 'dart:async';

import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/data/models/maintenance_model.dart';
import 'package:carstat/features/turbostat/data/models/operation_model.dart';
import 'package:carstat/features/turbostat/domain/entities/operation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carstat/services/auth_service.dart';

class DataService {
  String docId;
  String _userId;
  AuthService _firebaseAuth = AuthService();

  CollectionReference fs = Firestore.instance.collection('users');

/*
  Future<QuerySnapshot> checkUserDocs(String id) async {
    return fs.where('userId', isEqualTo: id).getDocuments().then((res) {
      if (res.documents.length == 0) fs.add({'userId': id});
      return res;
    });
  }

*/
  Future<QuerySnapshot> getData() async {
    _userId = await _firebaseAuth.currentUser().then((res) {
      print('current user for GetData is $res');
      return res;
    });

    QuerySnapshot _userDoc =
        await fs.where('userId', isEqualTo: _userId).getDocuments();

    if (_userDoc.documents.length != 0) {
      docId = _userDoc.documents[0].documentID;
      var result = await fs.document(docId).collection('cars').getDocuments();
      return result;
    } else {
      fs.document().setData({'userId': _userId});
      var result = await fs.document(_userId).collection('cars').getDocuments();
      return result;
    }
  }

  Future<void> addCar(CarModel car) async {
    await getData();
    var docRef = fs.document(docId).collection('cars').document();
    String _id = docRef.documentID;
    var data = {
      'carVin': car.carVin,
      'carModel': car.carModel,
      'carName': car.carName,
      'carMark': car.carMark,
      'carYear': car.carYear,
      'carId': _id
    };
    fs.document(docId).collection('cars').document(_id).setData(data);
  }

  Future<void> updateCarParameter(String carId, String parameter, value) async {
    await getData();
    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .updateData({parameter: value});
  }

  Future<void> updateCar(CarModel car) async {
    await getData();
    var data = {
      'carVin': car.carVin,
      'carModel': car.carModel,
      'carName': car.carName,
      'carMark': car.carMark,
      'carYear': car.carYear,
    };
    fs.document(docId).collection('cars').document(car.carId).updateData(data);
  }

  Future<void> deleteCar(String carId) async {
    await getData();
    fs.document(docId).collection('cars').document(carId).delete();
  }

  Future<void> addEntry(MaintenanceModel maintenanceModel, String carId) async {
    await getData();
    var maintenanceRef = fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document();

    var maintenanceData = {
      'maintenanceName': maintenanceModel.maintenanceName,
      'maintenanceMonthLimit': maintenanceModel.maintenanceMonthLimit,
      'maintenanceMileageLimit': maintenanceModel.maintenanceMileageLimit,
      'maintenanceId': maintenanceRef.documentID
    };

    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document(maintenanceRef.documentID)
        .setData(maintenanceData);
  }

  Future<List<MaintenanceModel>> getAllMaintenance(String carId) async {
    _userId = await _firebaseAuth.currentUser();
    List<MaintenanceModel> _maintenanciesList = [];

    if (_userId != null) {
      // проверка на ноль при выходе из аккаунта
      Future<QuerySnapshot> _userDoc =
          fs.where('userId', isEqualTo: _userId).getDocuments();
      await _userDoc.then((res) {
        docId = res.documents[0].documentID;
      });

      Future<QuerySnapshot> _carEntries = fs
          .document(docId)
          .collection('cars')
          .document(carId)
          .collection('maintenancies')
          .getDocuments();

      await _carEntries.then((res) {
        for (int i = 0; i < res.documents.length; i++) {
          var maintenance = MaintenanceModel(
            maintenanceId: res.documents[i].data['maintenanceId'],
            maintenanceName: res.documents[i].data['maintenanceName'],
            maintenanceMileageLimit: res.documents[i].data['maintenanceMileageLimit'],
            maintenanceMonthLimit: res.documents[i].data['maintenanceMonthLimit'],
          );
//          print(maintenance.maintenanceName); // print for debugging
          _maintenanciesList.add(maintenance);
        }
      });
    }

    return _maintenanciesList;
  }

  Future<void> addOperation(Operation operation, String carId) async {
    await getData();
    var maintenanceId = operation.maintenanceId;
    var operationRef = fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document(maintenanceId)
        .collection('operations')
        .document();

    var operationData = {
      'operationDate': operation.operationDate,
      'operationMileage': operation.operationMileage,
      'operationNote': operation.operationNote,
      'operationPrice': operation.operationPrice ?? 0.0,
      'maintenanceId': operation.maintenanceId,
      'operationId': operationRef.documentID
    };

    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document(maintenanceId)
        .collection('operations')
        .document(operationRef.documentID)
        .setData(operationData);
  }

  getEntryOperations(String maintenanceId, String carId) async {
    _userId = await _firebaseAuth.currentUser();
    List<Operation> _operations = [];
    Future<QuerySnapshot> _userDoc =
        fs.where('userId', isEqualTo: _userId).getDocuments();
    await _userDoc.then((res) {
      docId = res.documents[0].documentID;
    });
    Future<QuerySnapshot> _maintenanceOperations = fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document(maintenanceId)
        .collection('operations')
        .getDocuments();

    await _maintenanceOperations.then((val) {
      for (int i = 0; i < val.documents.length; i++) {
        var _operationModel = OperationModel(
          maintenanceId: maintenanceId,
          operationId: val.documents[i]['operationId'],
          operationPrice: val.documents[i].data['operationPrice'],
          operationDate: val.documents[i].data['operationDate'].toDate(),
          operationMileage: val.documents[i].data['operationMileage'],
          operationNote: val.documents[i].data['operationNote'],
        );

        _operations.add(_operationModel);
      }
    });
    return _operations;
  }

  Future<void> deleteOperation(
      String carId, String maintenanceId, String operationId) async {
    await getData();
    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document(maintenanceId)
        .collection('operations')
        .document(operationId)
        .delete();
  }

  Future<void> deleteEntry(String carId, String maintenanceId) async {
    await getData();
    fs
        .document(docId)
        .collection('cars')
        .document(carId)
        .collection('maintenancies')
        .document(maintenanceId)
        .delete();
  }

  Future<void> updateEntry(CarModel car, MaintenanceModel maintenanceModel) async {
    await getData();
    var data = {
      'maintenanceName': maintenanceModel.maintenanceName,
      'maintenanceMileageLimit': maintenanceModel.maintenanceMileageLimit,
      'maintenanceMonthLimit': maintenanceModel.maintenanceMonthLimit,
    };
    fs
        .document(docId)
        .collection('cars')
        .document(car.carId)
        .collection('maintenancies')
        .document(maintenanceModel.maintenanceId)
        .updateData(data);
  }
}
