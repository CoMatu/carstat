import 'dart:async';

import 'package:carstat/core/error/failures.dart';
import 'package:carstat/core/usecases/usecase.dart';
import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetConcreteCarModel implements UseCase<CarModel, Params>{
  final TurbostatRepository turbostatRepository;

  GetConcreteCarModel(this.turbostatRepository);

  @override
  Future<Either<Failure, CarModel>> call(params) async {
    return await turbostatRepository.getConcreteCarModel(params.carId);
  }


}

class Params extends Equatable {
  final String carId;

  Params({@required this.carId});

  @override
  List<Object> get props => [carId];
}