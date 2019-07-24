import 'package:carstat/models/entry.dart';
import 'package:carstat/services/data_service.dart';
import 'package:carstat/services/validators/number_validator.dart';
import 'package:flutter/material.dart';

import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/components/drawer.dart';

class AddEntryPage extends StatefulWidget {
  final String carId;

  AddEntryPage(this.carId);

  @override
  _AddEntryPageState createState() => _AddEntryPageState(carId);
}

class _AddEntryPageState extends State<AddEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Entry _entry = Entry();

  final String carId;

  _AddEntryPageState(this.carId);

  @override
  Widget build(BuildContext context) {
    print('for add entry to car ID: $carId');

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
                  'операции регламента технического обслуживания автомобиля, а '
                  'также периодичность проверки.'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ОТМЕНА', style: TextStyle(color: Colors.red),),
                  ),
                  FlatButton(
                    onPressed: _submitForm,
                    child: Text('СОХРАНИТЬ'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Форма заполнена некорректно! Исправьте ошибки...'),
        backgroundColor: Colors.red,
      ));
    } else {
      form.save();

      DataService().addEntry(_entry, carId);
      Navigator.pop(context);
    }
  }
}
