import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()

class Car extends Equatable {
  final String carId;
  final String carVin;
  final String carModel;
  final String carName;
  final String carMark;
  final int carYear;
  final int carMileage;

  Car({
    @required this.carId,
    @required this.carVin,
    @required this.carModel,
    @required this.carName,
    @required this.carMark,
    @required this.carYear,
    @required this.carMileage
  });

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
  Map<String, dynamic> toJson() => _$CarToJson(this);

  @override
  List<Object> get props => [
    carId,
    carVin,
    carModel,
    carMark,
    carName,
    carMileage,
    carYear,
  ];
}
