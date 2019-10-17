import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:carstat/features/turbostat/domain/usecases/get_all_car_models.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTurbostatRepository extends Mock implements TurbostatRepository {}

void main() {
  GetAllCarModels usecase;
  MockTurbostatRepository mockTurbostatRepository;

  setUp(() {
    mockTurbostatRepository = MockTurbostatRepository();
    usecase = GetAllCarModels(mockTurbostatRepository);
  });

  final String tUserId = 'matu1';
  final List<CarModel> tAllCarModels = [
    CarModel(
        carId: '1',
        carName: 'car 1',
        carMark: 'nissan',
        carModel: 'note',
        carYear: 2012,
        carVin: 'VIN123'),
    CarModel(
        carId: '2',
        carName: 'car 2',
        carMark: 'nissan',
        carModel: 'murano',
        carYear: 2017,
        carVin: 'VIN321'),
  ];

  test('should get cars for userId from the repository', () async {
    when(mockTurbostatRepository.getAllCarModels(any))
        .thenAnswer((_) async => Right(tAllCarModels));

    final result = await usecase(Params(userId: tUserId));

    expect(result, Right(tAllCarModels));
    verify(mockTurbostatRepository.getAllCarModels(tUserId));
    verifyNoMoreInteractions(mockTurbostatRepository);
  });
}
