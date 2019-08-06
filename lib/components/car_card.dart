import 'dart:async';
import 'package:flutter/material.dart';

import 'package:carstat/models/car.dart';
import 'package:carstat/services/data_service.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(
    BuildContext context, DataService dataService, String carId) async {
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
            child: const Text(
              'ОТМЕНА',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text(
              'УДАЛИТЬ',
            ),
            onPressed: () async {
              await dataService.deleteCar(carId).then(
                  (res) => Navigator.of(context).pop(ConfirmAction.ACCEPT));
            },
          )
        ],
      );
    },
  );
}

class CarCard extends StatelessWidget {
  final Car car;
  final Function() notifyCarsList;

  CarCard(this.car, {@required this.notifyCarsList});

  final DataService dataService = DataService();
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        children: <Widget>[
          Container(
              child: Image.asset('images/nissan_note.jpg'),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0)
            ),
          ),),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'dashboard_page',
                  arguments: car.carId);
            },
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: Text(car.carName)),
                Text(
                  'редактировать',
                  style: TextStyle(fontSize: 12.0, color: Colors.black38),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await _asyncConfirmDialog(context, dataService, car.carId);
                  },
                ),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(car.carMark),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(car.carModel),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(car.carYear.toString() + ' г.'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Пробег: ' + car.carMileage.toString() + ' км.'),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onTap: () {
                              _displayDialog(context, car.carId);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('VIN: ' + car.carVin),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'СОХРАНИТЬ',
                ),
                onPressed: () async {
                  await dataService
                      .updateCar(car.carId, 'carMileage',
                          int.parse(_textFieldController.text))
                      .then((res) {
                    notifyCarsList();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }
}
