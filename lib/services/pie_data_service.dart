import 'dart:async';

import 'package:carstat/features/turbostat/data/models/maintenance_model.dart';
import 'package:carstat/services/data_service.dart';

class PieDataService {
final DataService dataService = DataService();

  String carId;
  PieDataService(this.carId);

Future<List<MaintenanceModel>> getTotalCosts() async {
  List<MaintenanceModel> _entries = await dataService.getAllMaintenance(carId);
  return _entries; // тут возвращать нужно что-то другое, просто убрал варнинг
}
}