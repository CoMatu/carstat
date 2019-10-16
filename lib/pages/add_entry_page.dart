import 'package:carstat/features/turbostat/data/models/maintenance_model.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/services/data_service.dart';
import 'package:carstat/services/validators/number_validator.dart';
import 'package:flutter/material.dart';
import 'package:carstat/components/main_appbar.dart';

class AddEntryPage extends StatefulWidget {
  final String carId;

  AddEntryPage(this.carId);

  @override
  _AddEntryPageState createState() => _AddEntryPageState(carId);
}

class _AddEntryPageState extends State<AddEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String carId;

  String maintenanceName;
  int maintenanceMonthLimit;
  int maintenanceMileageLimit;

  _AddEntryPageState(this.carId);
  bool _forChange = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: MainAppBar(),
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
              Text(S.of(context).add_entry_page_description),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (val) => maintenanceName = val,
                decoration: InputDecoration(
                  labelText: S.of(context).form_decorator_maintenance_name,
                ),
              ),
              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).form_switch_check),
                  Switch(
                    value: _forChange,
                    onChanged: (value) {
                      setState(() {
                        _forChange = value;
                      });
                    },
                  ),
                  Text(S.of(context).form_switch_replacement)
                ],
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '12',
                validator: (val) => NumberValidator().numberValidator(val),
                onSaved: (val) => maintenanceMonthLimit = int.parse(val),
                decoration:
                    InputDecoration(labelText: S.of(context).form_decorator_maintenance_interval),
              ),
              Container(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '15000',
                validator: (val) => NumberValidator().numberValidator(val),
                onSaved: (val) => maintenanceMileageLimit = int.parse(val),
                decoration: InputDecoration(
                    labelText: S.of(context).form_decorator_maintenance_interval_km),
              ),
              Container(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context).button_cancel, style: TextStyle(color: Colors.red),),
                  ),
                  FlatButton(
                    onPressed: _submitForm,
                    child: Text(S.of(context).button_save),
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
        content: Text(S.of(context).snack_bar_message_warning),
        backgroundColor: Colors.red,
      ));
    } else {
      form.save();

      DataService().addEntry(MaintenanceModel(
        maintenanceId: '',
        maintenanceName: maintenanceName,
        maintenanceMileageLimit: maintenanceMileageLimit,
        maintenanceMonthLimit: maintenanceMonthLimit,
      ), carId);
      Navigator.pop(context);
    }
  }
}
