// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) {
  return Car(
    carId: json['carId'] as String,
    carVin: json['carVin'] as String,
    carModel: json['carModel'] as String,
    carName: json['carName'] as String,
    carMark: json['carMark'] as String,
    carYear: json['carYear'] as int,
    carMileage: json['carMileage'] as int,
  );
}

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'carId': instance.carId,
      'carVin': instance.carVin,
      'carModel': instance.carModel,
      'carName': instance.carName,
      'carMark': instance.carMark,
      'carYear': instance.carYear,
      'carMileage': instance.carMileage,
    };
