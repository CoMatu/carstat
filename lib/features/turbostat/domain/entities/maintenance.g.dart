// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Maintenance _$MaintenanceFromJson(Map<String, dynamic> json) {
  return Maintenance(
    maintenanceId: json['maintenanceId'] as String,
    maintenanceName: json['maintenanceName'] as String,
    maintenanceMileageLimit: json['maintenanceMileageLimit'] as int,
    maintenanceMonthLimit: json['maintenanceMonthLimit'] as int,
  );
}

Map<String, dynamic> _$MaintenanceToJson(Maintenance instance) =>
    <String, dynamic>{
      'maintenanceId': instance.maintenanceId,
      'maintenanceName': instance.maintenanceName,
      'maintenanceMileageLimit': instance.maintenanceMileageLimit,
      'maintenanceMonthLimit': instance.maintenanceMonthLimit,
    };
