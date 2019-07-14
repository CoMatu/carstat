import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  int currStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static Car car = Car();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<Step> steps = [
    Step(
        title: const Text('Название автомобиля'),
        isActive: true,
        state: StepState.indexed,
        content: TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
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
              labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)
          ),
        )
    ),
    Step(
        title: const Text('Марка автомобиля'),
        isActive: true,
        state: StepState.indexed,
        content: TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
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
              labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)
          ),
        )
    ),
    Step(
        title: const Text('Модель автомобиля'),
        isActive: true,
        state: StepState.indexed,
        content: TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
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
              labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)
          ),
        )
    ),
    Step(
        title: const Text('Год выпуска'),
        isActive: true,
        state: StepState.indexed,
        content: TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
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
              labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)
          ),
        )
    ),
    Step(
        title: const Text('Пробег'),
        isActive: true,
        state: StepState.indexed,
        content: TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
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
              labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)
          ),
        )
    ),
    Step(
        title: const Text('VIN'),
        isActive: true,
        state: StepState.indexed,
        content: TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
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
              labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid)
          ),
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {

    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Заполните необходимую информацию');
      } else {
        formState.save();
        print("Имя авто: ${car.carName}");
        print("Марка: ${car.carMark}");
        print("Модель: ${car.carModel}");
        print("Год выпуска: ${car.carYear}");
        print("Пробег: ${car.carMileage}");
        print("VIN: ${car.carVin}");

        AlertDialog(
              title: Text("Details"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Имя авто: " + car.carName),
                    Text("Марка: " + car.carMark),
                    Text("Модель: " + car.carModel),
                    Text("Год выпуска: " + car.carYear.toString()),
                    Text("Пробег: " + car.carMileage.toString()),
                    Text("VIN: " + car.carVin),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
      }
    }

    // TODO: implement build
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(children: <Widget>[
          Stepper(
            steps: steps,
            type: StepperType.vertical,
            currentStep: this.currStep,
            onStepContinue: () {
              setState(() {
                if (currStep < steps.length - 1) {
                  currStep = currStep + 1;
                } else {
                  currStep = 0;
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (currStep > 0) {
                  currStep = currStep - 1;
                } else {
                  currStep = 0;
                }
              });
            },
            onStepTapped: (step) {
              setState(() {
                currStep = step;
              });
            },
          ),
          FlatButton(
            child: Text('СОХРАНИТЬ ИНФОРМАЦИЮ',
            style: TextStyle(color: Colors.green[600]),),
            onPressed: _submitDetails,
          )
        ],),
      ),
    );
  }
}