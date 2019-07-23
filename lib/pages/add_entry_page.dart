import 'package:carstat/models/entry.dart';
import 'package:carstat/services/validators/date_validator.dart';
import 'package:carstat/services/validators/number_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/components/drawer.dart';

class AddEntryPage extends StatefulWidget {
  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();

  Entry _entry = Entry();

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 2015 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );

    if (result == null) return;

    setState(() {
      _controller.text = DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            children: <Widget>[
              Container(height: 30),
              Text('На этой странице необходимо ввести название проверки или '
                  'операции регламента технического обслуживания автомобиля. '),
              Text('Например,  "Замена моторного масла и масляного фильтра", '
                  'замена каждые 5000 км или 6 месяцев'),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (val) => _entry.entryName = val,
                decoration: const InputDecoration(
                  labelText: 'Название проверки (операции)',
                ),
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (val) => NumberValidator().numberValidator(val),
                onSaved: (val) => _entry.entryDateLimit = int.parse(val),
                decoration:
                    const InputDecoration(labelText: 'Периодичность, месяцев'),
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (val) => NumberValidator().numberValidator(val),
                onSaved: (val) => _entry.entryMileageLimit = int.parse(val),
                decoration: const InputDecoration(
                    labelText: 'Периодичность проверки, км'),
              ),
              Container(height: 30),
              Row(children: <Widget>[
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
//                        icon: const Icon(Icons.calendar_today),
                    labelText: 'Дата последней проверки (операции)',
                  ),
                  controller: _controller,
                  keyboardType: TextInputType.datetime,
                  validator: (val) => DateValidator().isValidDate(val)
                      ? null
                      : 'Неправильный формат даты',
                      onSaved: (val) => _entry.entryDate = convertToDate(val),
                )),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  tooltip: 'Выберите дату',
                  onPressed: (() {
                    _chooseDate(context, _controller.text);
                  }),
                ),
              ]),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (val) => _entry.entryPartName = val,
                decoration: const InputDecoration(
                    labelText: 'Расходный материал / запчасть'),
              ),
              Container(height: 30),
              TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.text,
                onSaved: (val) => _entry.entryNote = val,
                decoration: const InputDecoration(labelText: 'Заметки'),
              ),
              Container(height: 30),
              FlatButton(
                onPressed: _submitForm,
                child: Text('СОХРАНИТЬ'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if(!form.validate()) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text('Форма заполнена некорректно! Исправьте ошибки...'),
        backgroundColor: Colors.red,)
      );
    } else {
      form.save();
    }
  }
}
