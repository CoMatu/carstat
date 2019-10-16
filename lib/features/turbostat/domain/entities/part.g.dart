// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Part _$PartFromJson(Map<String, dynamic> json) {
  return Part(
    partId: json['partId'] as String,
    partName: json['partName'] as String,
    partCode: json['partCode'] as String,
    partPrice: (json['partPrice'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
      'partId': instance.partId,
      'partName': instance.partName,
      'partCode': instance.partCode,
      'partPrice': instance.partPrice,
    };
