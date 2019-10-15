import 'package:carstat/features/turbostat/domain/entities/car.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car_model.g.dart';

@JsonSerializable(explicitToJson: true)

class CarModel extends Car {
  CarModel({
    @required String carId,
    @required String carVin,
    @required String carModel,
    @required String carName,
    @required String carMark,
    @required int carYear,
    @required int carMileage,
  }) : super(
    carId: carId,
    carVin: carVin,
    carModel: carModel,
    carName: carName,
    carMark: carMark,
    carYear: carYear,
    carMileage: carMileage,
  );

  factory CarModel.fromJson(Map<String, dynamic> json) => _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);

}