import 'dart:io';

import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class EditCarPage extends StatefulWidget {
  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DataService _dataService = DataService();
  Car car;

  void _submitDetails() {
    final FormState formState = _formKey.currentState;
    formState.save();
    _dataService.updateCar(car).then((_) {
      Navigator.pushNamed(context, 'car_list_page');
    });


  }

  @override
  Widget build(BuildContext context) {
    car = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text('Редактировать информацию об авто:'),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carName,
                onSaved: (val) => car.carName = val,
                decoration: const InputDecoration(
                  labelText: 'Название автомобиля',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carMark,
                onSaved: (val) => car.carMark = val,
                decoration: const InputDecoration(
                  labelText: 'Марка автомобиля',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carModel,
                decoration: const InputDecoration(
                  labelText: 'Модель автомобиля',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carYear.toString(),
                onSaved: (val) => car.carYear = int.parse(val),
                decoration: const InputDecoration(
                  labelText: 'Год выпуска',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carVin,
                onSaved: (val) => car.carVin = val,
                decoration: const InputDecoration(
                  labelText: 'VIN',
                ),
              ),
              Container(height: 20.0,),
              FlatButton(
                child: Text('Удалить фото', style: TextStyle(color: Colors.red),),
                onPressed: _deleteImage,
              ),
              Text('* новую фотографию можно выбрать на странице списка Ваших машин', style: TextStyle(color: Colors.black26),),
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
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _deleteImage() async {
    final _fileName = car.carId + '.png';
    final dir = await getApplicationDocumentsDirectory();
    final String path = dir.path + '/' + _fileName;
    final File image = File(path);

    await image.delete();

  }
}
