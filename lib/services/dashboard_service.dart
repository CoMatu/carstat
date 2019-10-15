import 'dart:async';

import 'package:carstat/features/turbostat/domain/entities/entry.dart';
import 'package:carstat/services/data_service.dart';

  class DashboardService {
    DataService dataService = DataService();

    getMarkers(List<Entry> entries, String carId) async {
      var _marker = []; // коллекция списков операторов для каждого регламента ТО

      final opsForEntries = await Future.wait(
        entries.map((value) {
          return dataService.getEntryOperations(value.entryId, carId);
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
