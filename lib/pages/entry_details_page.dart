import 'dart:async';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
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
            child: Text(
              S.of(context).button_cancel,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: Text(
              S.of(context).button_delete,
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

Future<ConfirmAction> _asyncDeleteDialog(BuildContext context,
    DataService dataService, Car car, String entryId) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Удалить запись?'),
        content: const Text(
            'Вы удалите текущую запись и все связанные с ней данные без возможности восстановления'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              S.of(context).button_cancel,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: Text(
              S.of(context).button_delete,
            ),
            onPressed: () async {
              await dataService.deleteEntry(car.carId, entryId).then((res) =>
                  Navigator.pushNamed(context, 'dashboard_page',
                      arguments: car));
            },
          )
        ],
      );
    },
  );
}

class EntryDetailsPage extends StatefulWidget {
  final tile;
  final Car car;

  EntryDetailsPage(this.tile, this.car);

  @override
  _EntryDetailsPageState createState() => _EntryDetailsPageState(tile, car);
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  final tile;
  final Car car;
  String entryId;
  DataService dataService = DataService();
  List<Operation> _operns = [];
  NumberFormat _numberFormat;

  _EntryDetailsPageState(this.tile, this.car);

  Future<void> getOperations(String entryId) async {
    _operns = await dataService.getEntryOperations(entryId, car.carId);
    _operns.sort((a, b) {
      return b.operationDate.millisecondsSinceEpoch
          .compareTo(a.operationDate.millisecondsSinceEpoch);
    });
  }

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int entryDateLimit2 = tile['entry'].entryDateLimit;
    int entryMileageLimit2 = tile['entry'].entryMileageLimit;
    Locale myLocale = Localizations.localeOf(context);
    _numberFormat = NumberFormat.simpleCurrency(locale: myLocale.languageCode);

    return Scaffold(
      appBar: MainAppBar(),
//      drawer: MainDrawer(),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Column(
                    children: <Widget>[
                      Text(tile['entry'].entryName),
                      Divider()
                    ],
                  ),
                  subtitle: Column(
                    children: <Widget>[
                      Text(
                        S.of(context).entry_details_page_description(
                            entryDateLimit2.toString(),
                            entryMileageLimit2.toString()),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _asyncDeleteDialog(
                            context, dataService, car, tile['entry'].entryId);
                      },
                      child: Text(
                        S.of(context).button_delete,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    FlatButton(
                      child: Text(S.of(context).button_edit),
                      onPressed: () {
                        Navigator.pushNamed(context, 'edit_entry_page',
                            arguments: [tile['entry'], car]);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: getOperations(tile['entry'].entryId),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                    child: Padding(
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
                  String partPrice =
                      _numberFormat.format(_operns[index].partPrice);
                  String totalPrice = _numberFormat.format(
                      (_operns[index].partPrice +
                          _operns[index].operationPrice));
                  String operationPrice =
                      _numberFormat.format(_operns[index].operationPrice);
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
                                              S.of(context).date,
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
                                                S.of(context).km),
                                            Text(
                                              S.of(context).odometer,
                                              style: littleTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(totalPrice),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              S.of(context).parts,
                                              style: littleTextStyle,
                                            ),
                                            Text(
                                              partPrice,
                                              style: littleTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              S.of(context).works,
                                              style: littleTextStyle,
                                            ),
                                            Text(
                                              operationPrice,
                                              style: littleTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      print(_operns[index].operationId);
                                      await _asyncConfirmDialog(
                                          context,
                                          dataService,
                                          car.carId,
                                          _operns[index].entryId,
                                          _operns[index].operationId);
                                      setState(() {});
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
                                          S
                                              .of(context)
                                              .form_decorator_part_name,
                                          style: littleTextStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Text(
                                            _operns[index].operationPartName),
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
                                          S.of(context).form_decorator_notes,
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
