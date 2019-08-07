import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/entry.dart';
import 'package:flutter/material.dart';

class EntryDetailsPage extends StatefulWidget {
  final Entry entry;

  EntryDetailsPage(this.entry);

  @override
  _EntryDetailsPageState createState() => _EntryDetailsPageState(entry);
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  final Entry _entry;

  _EntryDetailsPageState(this._entry);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
//      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Column(
                children: <Widget>[Text(_entry.entryName), Divider()],
              ),
              subtitle: Column(
                children: <Widget>[
                  Text(
                    'Эту операцию необходимо выполнять каждые '
                    '${_entry.entryDateLimit} месяца или '
                    '${_entry.entryMileageLimit} км пробега (в зависимости от '
                    'того, что наступит раньше)',
                  ),
                  Divider(),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Дата: '),
                        ],
                      ),
                      Row(children: <Widget>[
                        Text('Показания спидометра: '),
                      ],),
                      Row(children: <Widget>[
                        Text('Наименование запасной части: '),
                      ],),
                      Row(children: <Widget>[
                        Text('Заметки: '),
                      ],),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
