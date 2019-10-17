import 'dart:convert';

import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/domain/entities/car.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tCarModel = CarModel(
      carId: '1',
      carName: 'car 1',
      carMark: 'nissan',
      carModel: 'note',
      carYear: 2012,
      carVin: 'VIN123');

  test('should be a subclass of Car entity', () async {
    expect(tCarModel, isA<Car>());
  });

  group('fromJson', () {
    test('should be return a valid model', () async {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('car.json'));

      final result = CarModel.fromJson(jsonMap);

      expect(result, tCarModel);
    });
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // act
        final result = tCarModel.toJson();
        // assert
        final expectedJsonMap = {
          "carId": "1",
          "carName": "car 1",
          "carMark": "nissan",
          "carModel": "note",
          "carYear": 2012,
          "carMileage": 83300,
          "carVin": "VIN123"
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}