import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';

class AddCar extends StatefulWidget {
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  int currStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static Car car = Car();
  DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Заполните необходимую информацию');
      } else {
        formState.save();

        var alert = AlertDialog(
          title: Text("Details"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Имя авто: ${car.carName}"),
                Text("Марка: ${car.carMark}"),
                Text("Модель: ${car.carModel}"),
                Text("Год выпуска: ${car.carYear}"),
                Text("Пробег: ${car.carMileage}"),
                Text("VIN: ${car.carVin}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ОТМЕНА'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _dataService.addCar(car).then((res) {
                  Navigator.pushNamed(context, 'car_list_page');
                });
              },
            ),
          ],
        );

        showDialog(context: context, builder: (_) => alert);
      }
    }

    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('На этой странице необходимо ввести информацию о Вашем автомобиле:', style: TextStyle(fontSize: 16.0),),
              ),
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                initialValue: 'Моя машина',
                autocorrect: false,
                onSaved: (String value) {
                  car.carName = value;
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Придумайте название авто',
                    labelStyle: TextStyle(
                      decorationStyle: TextDecorationStyle.solid,
                    )),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: '',
                autocorrect: false,
                onSaved: (String value) {
                  car.carMark = value;
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Пожалуйста, введите марку авто';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Введите марку автомобиля',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: '',
                autocorrect: false,
                onSaved: (String value) {
                  car.carModel = value;
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Пожалуйста, введите модель авто';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Введите модель автомобиля',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '',
                autocorrect: false,
                onSaved: (String value) {
                  car.carYear = int.parse(value);
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Пожалуйста, введите год выпуска';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Введите год выпуска',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '',
                autocorrect: false,
                onSaved: (String value) {
                  car.carMileage = int.parse(value);
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Пожалуйста, введите текущий пробег';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Введите текущий пробег',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: '',
                autocorrect: false,
                onSaved: (String value) {
                  car.carVin = value;
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Пожалуйста, введите VIN';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Введите VIN',
                ),
              ),
              Container(height: 30.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'car_list_page');
                    },
                    child: Text(
                      'ОТМЕНА',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  FlatButton(
                    child: Text('СОХРАНИТЬ'),
                    onPressed: _submitDetails,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
