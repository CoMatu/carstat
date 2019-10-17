import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:carstat/features/turbostat/domain/usecases/get_concrete_car_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTurbostatRepository extends Mock implements TurbostatRepository {}

void main() {
  GetConcreteCarModel usecase;
  MockTurbostatRepository mockTurbostatRepository;

  setUp(() {
    mockTurbostatRepository = MockTurbostatRepository();
    usecase = GetConcreteCarModel(mockTurbostatRepository);
  });

  final String tCarId = 'car1';
  final tCarModel = CarModel(
      carId: '1',
      carName: 'car 1',
      carMark: 'nissan',
      carModel: 'note',
      carYear: 2012,
      carVin: 'VIN123');

  test('should get car for carId from the repository', () async {
    when(mockTurbostatRepository.getConcreteCarModel(any))
        .thenAnswer((_) async => Right(tCarModel));

    final result = await usecase(Params(carId: tCarId));

    expect(result, Right(tCarModel));
    verify(mockTurbostatRepository.getConcreteCarModel(tCarId));
    verifyNoMoreInteractions(mockTurbostatRepository);
  });
}
