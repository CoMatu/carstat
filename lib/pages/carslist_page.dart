import 'dart:async';
import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';

import 'package:carstat/services/data_service.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Удалить автомобиль?'),
        content: const Text(
            'Вы удалите автомобиль из списка ваших транспортных средств без возможности восстановления'),
        actions: <Widget>[
          FlatButton(
            child: const Text('ОТМЕНА'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text(
              'УДАЛИТЬ',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class CarsListPage extends StatefulWidget {
  @override
  _CarsListPageState createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  bool isLoaded = false;
  DataService dataService = DataService();
  TextEditingController _textFieldController = TextEditingController();
  List<Car> _cars = [];
  Car car = Car();

  @override
  void initState() {
    dataService.getData().then((results) {
      List<Car> _res = [];
      results.documents.forEach((val) {
        car.carId = val.data['carId'];
        car.carVin = val.data['carVin'];
        car.carMileage = val.data['carMileage'];
        car.carYear = val.data['carYear'];
        car.carModel = val.data['carModel'];
        car.carMark = val.data['carMark'];
        car.carName = val.data['carName'];
        _res.add(car);
      });

      if (mounted) {
        setState(() {
          _cars = _res;
        });
      }
    });
    super.initState();
  }

  void _updateCarsList() {
    dataService.getData().then((results) {
      List<Car> _resUpd = [];
      results.documents.forEach((val) {
        car.carId = val.data['carId'];
        car.carVin = val.data['carVin'];
        car.carMileage = val.data['carMileage'];
        car.carYear = val.data['carYear'];
        car.carModel = val.data['carModel'];
        car.carMark = val.data['carMark'];
        car.carName = val.data['carname'];
        _resUpd.add(car);
      });

      if (mounted) {
        setState(() {
          _cars = _resUpd;
        });
      }
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
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _cars.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, index) {
            return Card(
                elevation: 8.0,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              image: DecorationImage(
                                  image: AssetImage('images/nissan_note.jpg'))),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, 'dashboard_page',
                                    arguments: _cars[index].carId);
                              },
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    _cars[index].carName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      onTap: () async {
                                        await _asyncConfirmDialog(context)
                                            .then((res) {
                                          DataService()
                                              .deleteCar(_cars[index].carId)
                                              .then((value) {
                                            _updateCarsList();
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Wrap(
                                children: <Widget>[
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Wrap(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 6.0, right: 6.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.teal),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Text(
                                              _cars[index].carYear.toString() +
                                                  ' г.',
                                              textAlign: TextAlign.center,
                                            )),
                                        Container(
                                          width: 15,
                                        ),
                                        Text(_cars[index].carMark),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(_cars[index].carModel),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Wrap(
                                      children: <Widget>[
                                        Text('VIN: '),
                                        Text(
                                          _cars[index].carVin,
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          _cars[index].carMileage.toString() +
                                              ' ' +
                                              'км',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            onTap: () {
                                              _displayDialog(
                                                  context, _cars[index].carId);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
      ],
    );
  }

  _displayDialog(BuildContext context, String documentID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _textFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Введите текущий пробег"),
              //TODO add validator for > 1 mln
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'ОТМЕНА',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'СОХРАНИТЬ',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                },
              )
            ],
          );
        });
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
