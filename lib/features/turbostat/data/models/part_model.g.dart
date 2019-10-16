// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartModel _$PartModelFromJson(Map<String, dynamic> json) {
  return PartModel(
    partId: json['partId'],
    partName: json['partName'],
    partCode: json['partCode'],
    partPrice: json['partPrice'],
  );
}

Map<String, dynamic> _$PartModelToJson(PartModel instance) => <String, dynamic>{
      'partId': instance.partId,
      'partName': instance.partName,
      'partCode': instance.partCode,
      'partPrice': instance.partPrice,
    };
