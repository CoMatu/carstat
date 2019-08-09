import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/services/data_service.dart';

class DashboardService {
  DataService dataService = DataService();

  getMarkers(List<Entry> entries, String carId) async{
    List<Operation> _operations = [];
    for(int i = 0; i < entries.length; i++) {
      _operations = await dataService
          .getEntryOperations(entries[i], carId).then((val) {
        for(int i = 0; i < val.length; i++) {
        }
        return val;
      });
    }

  }
}