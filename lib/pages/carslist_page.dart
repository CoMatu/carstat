import 'package:carstat/components/main_scafford.dart';
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
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    dataService.getData().then((results) {
      if (mounted) {
        setState(() {
          cars = results;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(body: _carList());
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
          return Card(
              elevation: 8.0,
              child: Container(
                height: 120,
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
                                fit: BoxFit.fitHeight,
                                image: AssetImage('images/nissan_note.jpg'))),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, 'dashboard_page',
                                  arguments: cars.documents[i].documentID);
                            },
                            title: Text(
                              cars.documents[0].data['carName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Container(
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.teal),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: Text(
                                            cars.documents[0].data['carYear']
                                                    .toString() +
                                                ' г.',
                                            textAlign: TextAlign.center,
                                          )),
                                      Container(
                                        width: 15,
                                      ),
                                      Text(
                                          cars.documents[0].data['carMark'] +
                                              ' ' +
                                              cars.documents[0]
                                                  .data['carModel'],
                                          style: TextStyle()),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('VIN: '),
                                      Text(
                                        cars.documents[0].data['carVin'],
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Пробег, км: '),
                                      Text(
                                        '87000',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: GestureDetector(
                                          child: Icon(Icons.edit, size: 14, color: Colors.orange,),
                                          onTap: () {
                                            _displayDialog(context);
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
      );
    } else {
      return Center(child: Text('Загрузка информации...'));
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Введите текущий пробег"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ОТМЕНА', style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('СОХРАНИТЬ', style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
