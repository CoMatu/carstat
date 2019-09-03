import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
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
        showSnackBarMessage(S.of(context).form_warning_fill_info);
      } else {
        formState.save();

        var alert = AlertDialog(
          title: Text(S.of(context).form_alert_details),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S.of(context).form_alert_car_name(car.carName)),
                Text(S.of(context).form_alert_car_mark(car.carMark)),
                Text(S.of(context).form_alert_car_model(car.carModel)),
                Text(S.of(context).form_alert_car_year(car.carYear.toString())),
                Text(S.of(context).form_alert_car_mileage(car.carMileage.toString())),
                Text("VIN: ${car.carVin}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).button_cancel),
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
                child: Text(S.of(context).add_car_page_description, style: TextStyle(fontSize: 16.0),),
              ),
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                initialValue: S.of(context).form_initial_my_car,
                autocorrect: false,
                onSaved: (String value) {
                  car.carName = value;
                },
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return S.of(context).form_validator_car_name;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: S.of(context).form_decorator_car_name,
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
                    return S.of(context).form_validator_car_mark;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_mark,
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
                    return S.of(context).form_validator_car_model;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.of(context).form_validator_car_model,
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
                    return S.of(context).form_validator_car_year;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_year,
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
                    return S.of(context).form_validator_car_mileage;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_mileage,
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
                    return S.of(context).form_validator_car_vin;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_vin,
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
                      S.of(context).button_cancel,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  FlatButton(
                    child: Text(S.of(context).button_save),
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
