import 'dart:async';

import 'package:carstat/core/error/failures.dart';
import 'package:carstat/core/usecases/usecase.dart';
import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:carstat/features/turbostat/domain/repositories/turbostat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetAllCarModels implements UseCase<List<CarModel>, Params> {
  final TurbostatRepository repository;

  GetAllCarModels(this.repository);

  @override
  Future<Either<Failure, List<CarModel>>> call(Params params) async {
    return await repository.getAllCarModels(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  Params({@required this.userId});

  @override
  List<Object> get props => [userId];
}
