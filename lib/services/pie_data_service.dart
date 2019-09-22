import 'package:carstat/models/entry.dart';
import 'package:carstat/services/data_service.dart';

class PieDataService {
final DataService dataService = DataService();
List<Entry> _entries;

getTotalCosts() async {
  _entries = [];
//  _entries = await dataService.getEntries(carId);
}
}