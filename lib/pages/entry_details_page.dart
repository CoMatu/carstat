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
              return Card(
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Text(f.format(_operns[index].operationDate)),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(_operns[index].operationMileage.toString()),
                      Text(_operns[index].operationPartName),
                      Text(_operns[index].operationNote)
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
