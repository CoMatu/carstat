import 'dart:async';

import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';

class DashboardService {
  DataService dataService = DataService();

  getMarkers(List<Entry> entries, String carId) async{
    print(entries[1].entryName);
    List<Operation> _operations = [];
    for(int i = 0; i < entries.length; i++) {
      print(entries[i].entryName + ' in FOR DashboardService');
      print(carId + ' in FOR DashboardService');
      _operations = await dataService
          .getEntryOperations(entries[i], carId).then((val) {
        for(int i = 0; i < val.length; i++) {
          var res = val[i].operationDate;
          print(res);
        }
        return val;
      });
    }

  }
}