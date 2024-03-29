import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/pages/dashboard_page.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';

class EditEntryPage extends StatefulWidget {
  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DataService _dataService = DataService();
  Entry _entry;
  Car _car;

  void _submitDetails() {
    final FormState formState = _formKey.currentState;
    formState.save();

    _dataService.updateEntry(_car, _entry).then((_){
      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage(_car)));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    List _data = ModalRoute.of(context).settings.arguments;
    _entry = _data[0];
    _car = _data[1];

    return Scaffold(
      key: _scaffoldKey,
      appBar: MainAppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                    S.of(context).edit_entry_page_title),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: _entry.entryName,
                onSaved: (val) => _entry.entryName = val,
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_maintenance_name,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: _entry.entryDateLimit.toString(),
                onSaved: (val) => _entry.entryDateLimit = int.parse(val),
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_maintenance_interval,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: _entry.entryMileageLimit.toString(),
                onSaved: (val) => _entry.entryMileageLimit = int.parse(val),
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_maintenance_interval_km,
                ),
              ),
              Container(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).button_cancel,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  FlatButton(
                    child: Text(S.of(context).button_save),
                    onPressed: () {
                      _submitDetails();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
