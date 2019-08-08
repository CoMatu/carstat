import 'dart:async';

import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';

class DashboardService {
  DataService dataService;

  getMarkers(List<Entry> entries, String carId) async{
    for(int i = 0; i < entries.length; i++) {
      List<Operation> _operations = await dataService
          .getEntryOperations(entries[i], carId);
    }
  }
}