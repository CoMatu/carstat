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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                )
              ],
            ),
            subtitle: Wrap(
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
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Пробег: ' + car.carMileage.toString() + ' км.'),
                      GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () {},
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
        ],
      ),
    );
  }

}