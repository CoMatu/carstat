import 'dart:async';

import 'package:carstat/core/error/failures.dart';
import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/data/models/mileage_model.dart';
import 'package:dartz/dartz.dart';

abstract class TurbostatRepository {
  Future<Either<Failure, CarModel>> getConcreteCarModel(String carId);
  Future<Either<Failure, List<CarModel>>> getAllCarModels(String userId);
  Future<Either<Failure, List<MileageModel>>> getAllMileageEntries(String carId);
}