import 'dart:io';
import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/features/turbostat/domain/entities/car.dart';
import 'package:carstat/generated/i18n.dart';
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
                child: Text(S.of(context).edit_car_page_title),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carName,
                onSaved: (val) => car.carName = val,
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_name,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carMark,
                onSaved: (val) => car.carMark = val,
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_mark,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carModel,
                onSaved: (val) => car.carModel = val,
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_model,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carYear.toString(),
                onSaved: (val) => car.carYear = int.parse(val),
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_year,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: car.carVin,
                onSaved: (val) => car.carVin = val,
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_car_vin,
                ),
              ),
              Container(height: 20.0,),
              FlatButton(
                child: Text(S.of(context).delete_image, style: TextStyle(color: Colors.red),),
                onPressed: _deleteImage,
              ),
              Text(S.of(context).new_image_info, style: TextStyle(color: Colors.black26),),
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

    final _snackbar = SnackBar(content: Text(S.of(context).image_deleted), backgroundColor: Colors.orange,);

    await image.delete().then((res) {
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    });

  }
}
