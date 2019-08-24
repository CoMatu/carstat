import 'dart:async';

import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(
    BuildContext context,
    DataService dataService,
    String carId,
    String entryId,
    String operationId) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Удалить запись?'),
        content: const Text(
            'Вы удалите текущую запись без возможности восстановления'),
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
              await dataService
                  .deleteOperation(carId, entryId, operationId)
                  .then(
                      (res) => Navigator.of(context).pop(ConfirmAction.ACCEPT));
            },
          )
        ],
      );
    },
  );
}

class EntryDetailsPage extends StatefulWidget {
  final tile;
  final String carId;

  EntryDetailsPage(this.tile, this.carId);

  @override
  _EntryDetailsPageState createState() => _EntryDetailsPageState(tile, carId);
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  final tile;
  final String carId;
  String entryId;
  DataService dataService = DataService();
  List<Operation> _operns = [];

  _EntryDetailsPageState(this.tile, this.carId);

  Future<void> getOperations(String entryId) async{
    _operns = await dataService.getEntryOperations(entryId, carId);
    _operns.sort((a, b) {
      return b.operationDate.millisecondsSinceEpoch
          .compareTo(a.operationDate.millisecondsSinceEpoch);
    });
  }

  @override
  void initState() {
    initializeDateFormatting("ru_RU", null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
//      drawer: MainDrawer(),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Column(
                children: <Widget>[Text(tile['entry'].entryName), Divider()],
              ),
              subtitle: Column(
                children: <Widget>[
                  Text(
                    'Эту операцию необходимо выполнять каждые '
                    '${tile['entry'].entryDateLimit} мес или '
                    '${tile['entry'].entryMileageLimit} км пробега (в зависимости от '
                    'того, что наступит раньше)',
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: getOperations(tile['entry'].entryId),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _operns.length,
                itemBuilder: (BuildContext context, index) {
                  var f = DateFormat('dd.MM.yyyy');
                  final littleTextStyle =
                  TextStyle(fontSize: 8.0, color: Colors.black38);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: CircleAvatar()),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(f.format(
                                                _operns[index].operationDate)),
                                            Text(
                                              'дата выполнения',
                                              style: littleTextStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(_operns[index]
                                                .operationMileage
                                                .toString() +
                                                ' км'),
                                            Text(
                                              'пробег',
                                              style: littleTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text((_operns[index]
                                                .partPrice + _operns[index].operationPrice)
                                                .toString()),
                                            Text(
                                              ' руб',
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Запчасти: ',
                                              style: littleTextStyle,
                                            ),
                                            Text(
                                              _operns[index].partPrice.toString(),
                                              style: littleTextStyle,
                                            ),
                                            Text(
                                              ' руб',
                                              style: littleTextStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Работа: ',
                                              style: littleTextStyle,
                                            ),
                                            Text(
                                              _operns[index]
                                                  .operationPrice
                                                  .toString(),
                                              style: littleTextStyle,
                                            ),
                                            Text(
                                              ' руб',
                                              style: littleTextStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red,),
                                    onPressed: () async {
                                      print(_operns[index].operationId);
                                      await _asyncConfirmDialog(
                                          context,
                                          dataService,
                                          carId,
                                          _operns[index].entryId,
                                          _operns[index].operationId);
                                      setState(() {

                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text(
                                          'Наименование расходных материалов и запчастей',
                                          style: littleTextStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child:
                                        Text(_operns[index].operationPartName),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text(
                                          'Заметки:',
                                          style: littleTextStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Text(
                                          _operns[index].operationNote,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

            },
          ),
        ],
      ),
    );
  }
}