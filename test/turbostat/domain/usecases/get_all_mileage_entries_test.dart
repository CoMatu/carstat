import 'package:carstat/features/turbostat/data/models/mileage_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:carstat/features/turbostat/domain/usecases/get_all_mileage_entries.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTurbostatRepository extends Mock implements TurbostatRepository {}

void main() {
  GetAllMileageEntries usecase;
  MockTurbostatRepository mockTurbostatRepository;

  setUp(() {
    mockTurbostatRepository = MockTurbostatRepository();
    usecase = GetAllMileageEntries(mockTurbostatRepository);
  });

  final String tCarId = 'car_1';
  final List<MileageModel> tAllMileageEntries = [
    MileageModel(
      entryMileageDate: DateTime(2019, 7, 22),
      mileage: 22222
    ),
    MileageModel(
        entryMileageDate: DateTime(2019, 9, 12),
        mileage: 34233
    ),
  ];

  test('should get cars for userId from the repository', () async {
    when(mockTurbostatRepository.getAllMileageEntries(any))
        .thenAnswer((_) async => Right(tAllMileageEntries));

    final result = await usecase(Params(carId: tCarId));

    expect(result, Right(tAllMileageEntries));
    verify(mockTurbostatRepository.getAllMileageEntries(tCarId));
    verifyNoMoreInteractions(mockTurbostatRepository);
  });
}
