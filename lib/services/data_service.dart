import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {

  CollectionReference fs = Firestore.instance.collection('users');

  Future<void> addData(List data) async {}

}