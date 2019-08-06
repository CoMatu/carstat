import 'package:carstat/models/car.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Car car;
  CarCard(this.car);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        children: <Widget>[
          Image.asset('images/nissan_note.jpg'),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: Text(car.carName)),
                Text('редактировать', style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black38
                ),),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
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
                          child: Text(car.carMark),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(car.carModel),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(car.carYear.toString() + ' г.'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Пробег: ' + car.carMileage.toString() + ' км.'),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            child: Icon(Icons.edit),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('VIN: ' + car.carVin),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}