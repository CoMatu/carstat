import 'dart:async';

import 'package:carstat/features/turbostat/data/models/car_model.dart';
import 'package:meta/meta.dart';

abstract class TurbostatRemoteDataSource {

  Future<List<CarModel>> getAllCarModels(String userId);

}

class TurbostatRemoteDataSourceImpl implements TurbostatRemoteDataSource {
  final user;

  TurbostatRemoteDataSourceImpl({@required this.user});

  @override
  Future<List<CarModel>> getAllCarModels(String userId) {
    return null;
  }

}