// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceModel _$MaintenanceModelFromJson(Map<String, dynamic> json) {
  return MaintenanceModel(
    maintenanceId: json['maintenanceId'],
    maintenanceName: json['maintenanceName'],
    maintenanceMileageLimit: json['maintenanceMileageLimit'],
    maintenanceMonthLimit: json['maintenanceMonthLimit'],
  );
}

Map<String, dynamic> _$MaintenanceModelToJson(MaintenanceModel instance) =>
    <String, dynamic>{
      'maintenanceId': instance.maintenanceId,
      'maintenanceName': instance.maintenanceName,
      'maintenanceMileageLimit': instance.maintenanceMileageLimit,
      'maintenanceMonthLimit': instance.maintenanceMonthLimit,
    };
