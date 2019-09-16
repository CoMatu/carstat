import 'dart:async';

import 'package:carstat/components/car_card.dart';
import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';
import 'package:carstat/services/data_service.dart';
import 'package:permission_handler/permission_handler.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class CarsListPage extends StatefulWidget {
  @override
  _CarsListPageState createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  bool isLoaded = false;
  DataService dataService = DataService();
  List<Car> _cars = [];
  Map<PermissionGroup, PermissionStatus> permissions;

  void getPermission() async {
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.storage,
    ]);
  }

  @override
  void initState() {
    getPermission();

    dataService.getData().then((results) {
      isLoaded = false;
      var _count = results.documents.length;
      for (int i = 0; i < _count; i++) {
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
      isLoaded = true;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void _updateCarsList() {
    isLoaded = false;

    dataService.getData().then((results) {
      var _count = results.documents.length;
      _cars = [];

      for (int i = 0; i < _count; i++) {
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
      isLoaded = true;
      setState(() {});
    });
  }

  Future<bool> _backButtonPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(S.of(context).will_pop_alert),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).button_cancel, style: TextStyle(color: Colors.black),),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _backButtonPressed,
        child: Scaffold(
          appBar: MainAppBar(),
          drawer: MainDrawer(),
//      floatingActionButton: _getFab(),
          body: _getBody(),
        ));
  }

  Widget _getBody() {
    if (!isLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      if (_cars.length == 0) {
        return Container(
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(
                S.of(context).car_list_page_warning,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: RaisedButton(
                child: Text(S.of(context).button_add_car),
                onPressed: () {
                  Navigator.pushNamed(context, 'add_car_page');
                },
                color: Colors.yellow,
              ),
            ),
          ),
        );
      } else {
        return _carList();
      }
    }
  }

  Widget _carList() {
    if (isLoaded) {
      return ListView(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: _cars.length,
            padding: EdgeInsets.all(5.0),
            itemBuilder: (context, index) {
              return CarCard(_cars[index], notifyCarsList: _updateCarsList);
            },
          ),
          Container(
            height: 90.0,
          )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

// TODO сделать предупреждение о работе с локальной копией БД если нет соединения
