import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carstat/pages/add_car_page.dart';
import 'package:carstat/services/data_service.dart';

class CarsListPage extends StatefulWidget {

  @override
  _CarsListPageState createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  bool isLoaded = false;
  QuerySnapshot cars;

  DataService dataService = DataService();

  @override
  void initState() {
    dataService.getData().then((results) {
      setState(() {
        cars = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _carList();
  }

  Widget _carList() {
    if (cars != null) {
      if (cars.documents.length == 0) {
        return AddCarPage();
      }
      return ListView.builder(
        itemCount: cars.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return new ListTile(
            title: Text(cars.documents[i].data['carName']),
            subtitle: Text('car colors'),
          );
        },
      );
    } else {
      return Center(child: Text('Загрузка информации...'));
    }
  }
}