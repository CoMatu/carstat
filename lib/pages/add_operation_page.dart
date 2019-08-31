import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';
import 'package:carstat/services/validators/date_validator.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/components/drawer.dart';

class AddOperationPage extends StatefulWidget {
  final Car car;
  final List<Entry> entries;

  AddOperationPage(this.car, this.entries);

  @override
  _AddOperationPageState createState() =>
      _AddOperationPageState(car, entries);
}

class _AddOperationPageState extends State<AddOperationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();

  List<String> _entriesNames = <String>[];
  Operation _operation = Operation();

  final Car car;
  final List<Entry> _entries;

  _AddOperationPageState(this.car, this._entries);

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    assert(initialDate != null);
    print(initialDate.toString());
    initialDate = (initialDate.year >= 2015 && initialDate.isBefore(now)
        ? initialDate
        : now);

    print('after ' + initialDate.toString());

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    print('result ' + result.toString());
    if (result == null) return;

    setState(() {
      _controller.text = DateFormat('dd.MM.yyyy').format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = DateFormat('dd.MM.yyyy').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    _entries.forEach((res) {
      _entriesNames.add(res.entryName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentMileage = car.carMileage.toString();
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
                  Text('На этой странице необходимо записать выполненную проверку'
                      ' или операцию ТО, показания спидометра, использованные '
                      'расходники или запчасти'),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Выберите проверку из списка',
                            labelStyle: TextStyle(fontSize: 22.0)),
                        isEmpty: _operation.entryId == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _operation.entryId,
                            isDense: true,
                            isExpanded: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _operation.entryId = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _entries.map((Entry value) {
                              return DropdownMenuItem<String>(
                                value: value.entryId,
                                child: Text(value.entryName),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(height: 30),
                  Row(children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(
    //                        icon: const Icon(Icons.calendar_today),
                        labelText: 'Дата проверки (операции)',
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                      validator: (val) => DateValidator().isValidDate(val)
                          ? null
                          : 'Неправильный формат даты',
                      onSaved: (val) => _operation.operationDate =
                          DateFormat('dd.MM.yyyy').parseStrict(val),
                    )),
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      tooltip: 'Выберите дату',
                      onPressed: (() {
                        assert(_controller.text != null);
                        _chooseDate(context, _controller.text);
                      }),
                    ),
                  ]),
                  Container(height: 30),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: currentMileage,
                onSaved: (val) {
                  _operation.operationMileage = int.parse(val);
                }
                ,
                decoration:
                    const InputDecoration(labelText: 'Текущий пробег, км'),
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: '',
                onSaved: (val) => _operation.operationPartName = val,
                decoration: const InputDecoration(
                    labelText: 'Расходный материал / запчасть'),
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '0',
                validator: (value) {
                  if (value.contains(',')) {
                    return 'Используйте точку . для разрядов';
                  }
                  return null;
                },
                onSaved: (val) => _operation.operationPrice = double.parse(val),
                decoration: const InputDecoration(labelText: 'Стоимость работ'),
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '0',
                validator: (value) {
                  if (value.contains(',')) {
                    return 'Используйте точку . для разрядов';
                  }
                  return null;
                },
                onSaved: (val) => _operation.partPrice = double.parse(val),
                decoration:
                    const InputDecoration(labelText: 'Стоимость запчастей'),
              ),
              Container(height: 30),
              TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.text,
                initialValue: '',
                onSaved: (val) => _operation.operationNote = val,
                decoration: const InputDecoration(labelText: 'Заметки'),
              ),
              Container(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ОТМЕНА',
                      style: TextStyle(color: Colors.red),
                    ),
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
      print(form.toString());
      form.save();

      DataService().addOperation(_operation, car.carId);
      Navigator.pop(context);
    }
  }

}

// TODO: сделать изменение пробега при добавлении операций + проверять, чтобы каждый новый пробег был больше предыдущего
