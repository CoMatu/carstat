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
        setState(() {});
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
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _cars.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, index) {
//            print(_cars[index].carName);
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
                              title: Wrap(
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
                                        size: 24,
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
                                              size: 24.0,
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
