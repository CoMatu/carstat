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
      if (_operations.length != 0) {
        _operations.sort((a, b) {
          return a.operationDate.millisecondsSinceEpoch
              .compareTo(b.operationDate.millisecondsSinceEpoch);
        });
        _marker.add({'entry': entries[i],'operations': _operations});
      }
      return _marker;
    }
  }
}
