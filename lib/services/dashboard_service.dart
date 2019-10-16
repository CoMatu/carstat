import 'dart:async';

import 'package:carstat/features/turbostat/data/models/maintenance_model.dart';
import 'package:carstat/services/data_service.dart';

  class DashboardService {
    DataService dataService = DataService();

    getMarkers(List<MaintenanceModel> entries, String carId) async {
      var _marker = []; // коллекция списков операторов для каждого регламента ТО

      final opsForEntries = await Future.wait(
        entries.map((value) {
          return dataService.getEntryOperations(value.maintenanceId, carId);
        })
      );

       for(int i = 0; i < entries.length; i++) {
         _marker.add(
           {
             'entry': entries[i],
             'operations': opsForEntries[i]
           }
         );
       }

      return _marker;
    }
  }
