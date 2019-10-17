// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mileage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MileageModel _$MileageModelFromJson(Map<String, dynamic> json) {
  return MileageModel(
    entryMileageDate: json['entryMileageDate'] == null
        ? null
        : DateTime.parse(json['entryMileageDate'] as String),
    mileage: json['mileage'] as int,
  );
}

Map<String, dynamic> _$MileageModelToJson(MileageModel instance) =>
    <String, dynamic>{
      'entryMileageDate': instance.entryMileageDate?.toIso8601String(),
      'mileage': instance.mileage,
    };
