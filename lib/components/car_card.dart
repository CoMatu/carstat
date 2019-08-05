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
              children: <Widget>[
                Text(car.carName),
              ],
            ),
          ),
        ],
      ),
    );
  }

}