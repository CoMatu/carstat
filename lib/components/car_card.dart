import 'dart:async';
import 'dart:io';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:carstat/models/car.dart';
import 'package:carstat/services/data_service.dart';
import 'package:image_picker/image_picker.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> _asyncConfirmDialog(
    BuildContext context, DataService dataService, String carId) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).car_card_alert_dialog_title),
        content: Text(S.of(context).car_card_content_text),
        actions: <Widget>[
          FlatButton(
            child: Text(
              S.of(context).button_cancel,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: Text(
              S.of(context).button_delete,
            ),
            onPressed: () async {
              await dataService.deleteCar(carId).then(
                  (res) => Navigator.of(context).pop(ConfirmAction.ACCEPT));
            },
          )
        ],
      );
    },
  );
}

class CarCard extends StatefulWidget {
  final Car car;
  final Function() notifyCarsList;

  CarCard(this.car, {@required this.notifyCarsList});

  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  final DataService dataService = DataService();

  final TextEditingController _textFieldController = TextEditingController();

  File _image;
  String _fileName;

  Future getImage() async {
    _fileName = widget.car.carId + '.png';
    final dir = await getApplicationDocumentsDirectory();
    final String path = dir.path + '/' + _fileName;
    final File image = File(path);
    _image = image;
  }

  Future getImageFromCam() async {
    // for camera
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);
    _saveImage(image);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    // for gallery
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _saveImage(image);
    setState(() {
      _image = image;
    });
  }

  Future _saveImage(File image) async {
    if (image == null) return;
    _fileName = widget.car.carId + '.png';
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File imageFile = await image.copy('$path/$_fileName');
    setState(() {
      _image = imageFile;
    });
  }

  getAutoImage(File image) {
    return Container(
            child: !image.existsSync()
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          S.of(context).car_card_no_image_selected,
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                      Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              onPressed: getImageFromCam,
                              heroTag: null,
                              tooltip: 'Pick Image',
                              child: Icon(Icons.add_a_photo),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              onPressed: getImageFromGallery,
                              heroTag: null,
                              tooltip: 'Pick Image',
                              child: Icon(Icons.wallpaper),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DashboardPage(widget.car)
                ));
              },
              child: FittedBox(
                fit: BoxFit.fitWidth,
                  child: Image.file(image)),
            ))
        ;
  }

  @override
  Widget build(BuildContext context) {
    String _mileage = widget.car.carMileage.toString();
    return Card(
      elevation: 8,
      child: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: 400,
            child: FutureBuilder(
              future: getImage(),
              builder: ((BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 35.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                return getAutoImage(_image);
              }),
            ),
            // Image.asset('images/nissan_note.jpg'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DashboardPage(widget.car)
              ));
            },
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: Text(widget.car.carName)),
                FlatButton(
                  child: Text(
                    S.of(context).car_card_change,
                    style: TextStyle(fontSize: 12.0, color: Colors.black26),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'edit_car_page',
                        arguments: widget.car);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await _asyncConfirmDialog(
                        context, dataService, widget.car.carId);
                    Navigator.pushNamed(context, 'car_list_page');
                  },
                ),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(widget.car.carMark),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(widget.car.carModel),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(widget.car.carYear.toString() + ' г.'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(S.of(context).car_card_mileage(_mileage)),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onTap: () {
                              _displayDialog(context, widget.car.carId);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('VIN: ' + widget.car.carVin),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _displayDialog(BuildContext context, String documentID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _textFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: S.of(context).car_card_enter_current_mileage),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  S.of(context).button_cancel,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  S.of(context).button_save,
                ),
                onPressed: () async {
                  await dataService
                      .updateCarParameter(widget.car.carId, 'carMileage',
                          int.parse(_textFieldController.text))
                      .then((res) {
                    widget.notifyCarsList();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }
}
