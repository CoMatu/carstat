import 'dart:async';

import 'package:carstat/core/error/failures.dart';
import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/data/models/mileage_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:dartz/dartz.dart';

class TurbostatRepositoryImpl implements TurbostatRepository {
  @override
  Future<Either<Failure, List<CarModel>>> getAllCarModels(String userId) {
    // TODO: implement getAllCarModels
    return null;
  }

  @override
  Future<Either<Failure, List<MileageModel>>> getAllMileageEntries(String carId) {
    // TODO: implement getAllMileageEntries
    return null;
  }

  @override
  Future<Either<Failure, CarModel>> getConcreteCarModel(String carId) {
    // TODO: implement getConcreteCarModel
    return null;
  }

}