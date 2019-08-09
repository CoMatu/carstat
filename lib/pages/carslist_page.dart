import 'package:carstat/components/car_card.dart';
import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';
import 'package:carstat/services/data_service.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class CarsListPage extends StatefulWidget {
  @override
  _CarsListPageState createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  bool isLoaded = false;
  DataService dataService = DataService();
  List<Car> _cars = [];

  @override
  void initState() {
    dataService.getData().then((results) {
      var _count = results.documents.length;
      for(int i = 0; i < _count; i++) {
        Car car = Car();
        car.carId = results.documents[i].data['carId'];
        car.carVin = results.documents[i].data['carVin'];
        car.carMileage = results.documents[i].data['carMileage'];
        car.carYear = results.documents[i].data['carYear'];
        car.carModel = results.documents[i].data['carModel'];
        car.carMark = results.documents[i].data['carMark'];
        car.carName = results.documents[i].data['carName'];
        _cars.add(car);
      }

      if(mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void _updateCarsList() {
    dataService.getData().then((results) {
      var _count = results.documents.length;
      _cars = [];

      for(int i = 0; i < _count; i++) {
        Car car = Car();
        car.carId = results.documents[i].data['carId'];
        print(car.carId);
        car.carVin = results.documents[i].data['carVin'];
        car.carMileage = results.documents[i].data['carMileage'];
        car.carYear = results.documents[i].data['carYear'];
        car.carModel = results.documents[i].data['carModel'];
        car.carMark = results.documents[i].data['carMark'];
        car.carName = results.documents[i].data['carName'];
        _cars.add(car);
      }
        print('after delete -' + _cars.length.toString());
        setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      floatingActionButton: _getFab(),
      body: _carList(),
    );
  }

  Widget _carList() {
    return ListView(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _cars.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, index) {
//            print(_cars[index].carName);
            return CarCard(_cars[index], notifyCarsList: _updateCarsList);
          },
        ),
        Container(
          height: 90.0,
        )
      ],
    );
  }

  _getFab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, 'add_car_page');
      },
    );
  }
}