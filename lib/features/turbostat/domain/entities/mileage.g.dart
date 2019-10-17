// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mileage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mileage _$MileageFromJson(Map<String, dynamic> json) {
  return Mileage(
    entryMileageDate: json['entryMileageDate'] == null
        ? null
        : DateTime.parse(json['entryMileageDate'] as String),
    mileage: json['mileage'] as int,
  );
}

Map<String, dynamic> _$MileageToJson(Mileage instance) => <String, dynamic>{
      'entryMileageDate': instance.entryMileageDate?.toIso8601String(),
      'mileage': instance.mileage,
    };
