import 'dart:convert';

import 'package:carstat/features/turbostat/data/models/maintenance_model.dart';
import 'package:carstat/features/turbostat/domain/entities/maintenance.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tMaintenanceModel = MaintenanceModel(
    maintenanceId: '1',
    maintenanceName: 'Cabin filter',
    maintenanceMonthLimit: 12,
    maintenanceMileageLimit: 15000,
  );

  test('should be a subclass of Maintenance entity', () async {
    expect(tMaintenanceModel, isA<Maintenance>());
  });

  group('fromJson', () {
    test('should be return a valid model', () async {
      final Map<String, dynamic> jsonMap =
      jsonDecode(fixture('maintenance.json'));

      final result = MaintenanceModel.fromJson(jsonMap);

      expect(result, tMaintenanceModel);
    });
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // act
        final result = tMaintenanceModel.toJson();
        // assert
        final expectedJsonMap = {
          "maintenanceId": "1",
          "maintenanceName": "Cabin filter",
          "maintenanceMonthLimit": 12,
          "maintenanceMileageLimit": 15000,
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}