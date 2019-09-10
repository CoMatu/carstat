import 'dart:async';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/pages/dashboard_page.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

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
        title: Text(S.of(context).delete_entry_operation),
        content: Text(S.of(context).delete_entry_operation_warning),
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
        title: Text(S.of(context).delete_entry_operation),
        content: Text(S.of(context).delete_entry_operation_warning),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardPage(car))));
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
  int entryDateLimit2;
  int entryMileageLimit2;

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
    entryDateLimit2 = tile['entry'].entryDateLimit;
    entryMileageLimit2 = tile['entry'].entryMileageLimit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      Row(
                        children: <Widget>[
                          Expanded(child: Text(tile['entry'].entryName)),
                          _simplePopup()
                        ],
                      ),
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
/*
                                Table(
                                  children: <TableRow>[
                                    TableRow(children: )
                                  ],
                                )
*/
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

  Widget _simplePopup() => PopupMenuButton<String>(
        onSelected: choiceAction,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: S.of(context).button_delete_camel,
            child: Row(
              children: <Widget>[
                Icon(Icons.delete),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(S.of(context).button_delete_camel),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: S.of(context).button_edit_camel,
            child: Row(
              children: <Widget>[
                Icon(Icons.edit),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(S.of(context).button_edit_camel),
                ),
              ],
            ),
          ),
          _operns.length != 0
              ? PopupMenuItem(
                  // hide add to calendar button if have not operations
                  value: S.of(context).button_add_calendar_camel,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(S.of(context).button_add_calendar_camel),
                      ),
                    ],
                  ),
                )
              : null,
        ],
      );

  void choiceAction(String value) {
    if (value == S.of(context).button_delete_camel) {
      print('DELETE');
      _asyncDeleteDialog(context, dataService, car, tile['entry'].entryId);
    } else {
      if (value == S.of(context).button_edit_camel) {
        print('EDIT');
        Navigator.pushNamed(context, 'edit_entry_page',
            arguments: [tile['entry'], car]);
      }
      if (value == S.of(context).button_add_calendar_camel) {
//        print(tile['entry'].entryDateLimit * 30);
//        print(DateTime.now().difference(_operns[0].operationDate).inDays);
        int duration = tile['entry'].entryDateLimit * 30 -
            DateTime.now().difference(_operns[0].operationDate).inDays;
        final Event event = Event(
          title: tile['entry'].entryName,
          description: S.of(context).entry_details_page_description(
              entryDateLimit2.toString(), entryMileageLimit2.toString()),
          startDate: DateTime.now().add(Duration(days: duration)),
          endDate: DateTime.now().add(Duration(days: duration + 1)),
        );
        Add2Calendar.addEvent2Cal(event);
      }
    }
  }
}
