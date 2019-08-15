import 'dart:async';
import 'package:collection/collection.dart';

import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';

class DashboardService {
  DataService dataService = DataService();

  getMarkers(List<Entry> entries, String carId) async {
    var _marker = []; // коллекция списков операторов для каждого регламента ТО

    // Получаю списки операций для регламентов ТО
/*
    for (int i = 0; i < entries.length; i++) {
      List<Operation> _operations = [];
      _operations =
          await dataService.getEntryOperations(entries[i].entryId, carId);
      _marker.add({'entry': entries[i], 'operations': _operations});

    }
*/

    final opsForEntries = await Future.wait(
      entries.map((value) {
        return dataService.getEntryOperations(value.entryId, carId);
      })
    );

    final zipped = IterableZip([entries, opsForEntries]);
    return zipped.map(([entry, ops]) => ({'entry': entry, 'operations': ops}));
  }
}
