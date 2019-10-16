// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationModel _$OperationModelFromJson(Map<String, dynamic> json) {
  return OperationModel(
    operationId: json['operationId'] as String,
    operationDate: json['operationDate'] == null
        ? null
        : DateTime.parse(json['operationDate'] as String),
    maintenanceId: json['maintenanceId'] as String,
    operationPrice: (json['operationPrice'] as num)?.toDouble(),
    operationMileage: json['operationMileage'] as int,
    operationNote: json['operationNote'] as String,
  );
}

Map<String, dynamic> _$OperationModelToJson(OperationModel instance) =>
    <String, dynamic>{
      'operationDate': instance.operationDate?.toIso8601String(),
      'operationMileage': instance.operationMileage,
      'operationNote': instance.operationNote,
      'maintenanceId': instance.maintenanceId,
      'operationPrice': instance.operationPrice,
      'operationId': instance.operationId,
    };
