import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';

class DashboardService {
  DataService dataService = DataService();

  getMarkers(List<Entry> entries, String carId) async {
    var _marker = []; // коллекция списков операторов для каждого регламента ТО

    // Получаю списки операций для регламентов ТО
    for (int i = 0; i < entries.length; i++) {
      List<Operation> _operations =
          await dataService.getEntryOperations(entries[i], carId);
      _sortByDateTime(_operations);
      _marker.add({'entryId': entries[i].entryId, 'operations': _operations});
    }
    return _marker;
  }

  _sortByDateTime(List<Operation> operations) {
    List<Operation> _sortedOperations = [];
    
  }
}
