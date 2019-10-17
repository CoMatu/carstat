import 'dart:async';

import 'package:carstat/core/error/failures.dart';
import 'package:carstat/core/usecases/usecase.dart';
import 'package:carstat/features/turbostat/data/models/mileage_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetAllMileageEntries implements UseCase<List<MileageModel>, Params> {
  final TurbostatRepository repository;

  GetAllMileageEntries(this.repository);

  @override
  Future<Either<Failure, List<MileageModel>>> call(Params params) async {
    return await repository.getAllMileageEntries(params.carId);
  }
}

class Params extends Equatable {
  final String carId;

  Params({@required this.carId});

  @override
  List<Object> get props => [carId];
}
