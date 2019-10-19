import 'package:carstat/features/turbostat/domain/usecases/get_all_sorted_tiles.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/sorted_tile.dart';
import 'package:carstat/services/dashboard_service.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataService extends Mock implements DataService {}

class MockDashboardService extends Mock implements DashboardService {}

void main() {
  GetAllSortedTiles usecase;
  MockDataService mockDataService;
  MockDashboardService mockDashboardService;

  setUp(() {
    mockDataService = MockDataService();
    mockDashboardService = MockDashboardService();

  });

  Car tCar = Car();
  tCar.carId = '123';

  Entry entry = Entry();
  entry.entryId = '123';
  entry.forChange = true;
  entry.entryMileageLimit = 15000;
  entry.entryDateLimit = 12;
  entry.entryName = 'name';

  testWidgets('should get list of SortedTile', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          usecase = GetAllSortedTiles(context: context, car: tCar);


          return Placeholder();
        },
      ),
    );
  });
}
