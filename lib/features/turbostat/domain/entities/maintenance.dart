// проверка или операция регламента ТО. Например, замена масла и масляного фильтра

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'maintenance.g.dart';

@JsonSerializable()

class Maintenance extends Equatable{
  final String maintenanceId;
  final String maintenanceName;
  final int maintenanceMileageLimit;
  final int maintenanceMonthLimit;

  Maintenance(
      {@required this.maintenanceId,
      @required this.maintenanceName,
      @required this.maintenanceMileageLimit,
      @required this.maintenanceMonthLimit});

  factory Maintenance.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceToJson(this);

  @override
  List<Object> get props => [
    maintenanceId,
    maintenanceName,
    maintenanceMileageLimit,
    maintenanceMonthLimit
  ];

}
