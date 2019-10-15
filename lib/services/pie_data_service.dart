import 'dart:async';

import 'package:carstat/features/turbostat/domain/entities/entry.dart';
import 'package:carstat/services/data_service.dart';

class PieDataService {
final DataService dataService = DataService();

  String carId;
  PieDataService(this.carId);

Future<List<Entry>> getTotalCosts() async {
  List<Entry> _entries = await dataService.getEntries(carId);
  return _entries; // тут возвращать нужно что-то другое, просто убрал варнинг
}
}