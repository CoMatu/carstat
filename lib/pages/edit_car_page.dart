import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';

class EditCarPage extends StatefulWidget {
  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Car car = ModalRoute.of(context).settings.arguments;
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
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Редактировать информацию об авто:'),
              )),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carName,
                decoration: const InputDecoration(
                  labelText: 'Название автомобиля',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carMark,
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
                initialValue: car.carVin,
                decoration: const InputDecoration(
                  labelText: 'VIN',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
