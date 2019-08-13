import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class EntryDetailsPage extends StatefulWidget {
  final tile;

  EntryDetailsPage(this.tile);

  @override
  _EntryDetailsPageState createState() => _EntryDetailsPageState(tile);
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  var tile;

  _EntryDetailsPageState(this.tile);

  @override
  void initState() {
    initializeDateFormatting("ru_RU", null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Operation> _operns = tile['operations'];
    _operns.sort((a, b) {
      return b.operationDate.millisecondsSinceEpoch
          .compareTo(a.operationDate.millisecondsSinceEpoch);
    });
    return Scaffold(
      appBar: MainAppBar(),
//      drawer: MainDrawer(),
      body: Column(
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
                    '${tile['entry'].entryDateLimit} месяца или '
                    '${tile['entry'].entryMileageLimit} км пробега (в зависимости от '
                    'того, что наступит раньше)',
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
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
                              flex: 3,
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
                              flex: 2,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(_operns[index].partPrice.toString()),
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
                                    style: littleTextStyle,),
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
                                        'Заметки:',
                                    style: littleTextStyle,),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: Text(
                                        _operns[index].operationNote,),
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
          )
        ],
      ),
    );
  }
}
