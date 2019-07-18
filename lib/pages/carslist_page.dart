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
      return
        ListView.builder(
        itemCount: cars.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return Card(
            elevation: 8.0,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, 'dashboard_page');
              },
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              width: 1.0, color: Colors.green))),
                  child: Icon(Icons.directions_car, color: Colors.green),
                ),
                title: Text(
                  cars.documents[0].data['carName'],
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    Text(cars.documents[0].data['carMark']+' '+cars.documents[0].data['carModel'], style: TextStyle(color: Colors.grey))
                  ],
                ),
                trailing:
                Icon(Icons.keyboard_arrow_right, color: Colors.green,
                    size: 30.0))
            ,
          );
        },
      );
    } else {
      return Center(child: Text('Загрузка информации...'));
    }
  }
}