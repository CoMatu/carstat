import 'dart:convert';

import 'package:carstat/features/turbostat/data/models/operation_model.dart';
import 'package:carstat/features/turbostat/domain/entities/operation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tEntryModel = OperationModel(
      operationId: '1',
      maintenanceId: '1',
      operationDate: DateTime(2019, 7, 22),
      operationMileage: 80000,
      operationPrice: 200.00,
      operationNote: "operation note");

  test('should be a subclass of Entry entity', () async {
    expect(tEntryModel, isA<Operation>());
  });

  group('fromJson', () {
    test('should be return a valid model', () async {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('operation.json'));

      final result = OperationModel.fromJson(jsonMap);

      expect(result, tEntryModel);
    });
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // act
        final result = tEntryModel.toJson();
        // assert
        final expectedJsonMap = {
          "operationId": "1",
          "maintenanceId": "1",
          "operationDate": "2019-07-22T00:00:00.000",
          "operationMileage": 80000,
          "operationPrice": 200.00,
          "operationNote": "operation note"
        };
        expect(result, expectedJsonMap);
      },
    );
  });

}