import 'dart:async';

import 'package:carstat/models/entry.dart';
import 'package:carstat/services/data_service.dart';

class PieDataService {
final DataService dataService = DataService();
List<Entry> _entries = [];

  String carId;
  PieDataService(this.carId);

Future getTotalCosts() async {
  _entries = await dataService.getEntries(carId);
}
}