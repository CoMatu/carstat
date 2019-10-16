import 'package:carstat/features/turbostat/domain/entities/maintenance.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'maintenance_model.g.dart';

@JsonSerializable(explicitToJson: true)

class MaintenanceModel extends Maintenance {
  MaintenanceModel(
      {@required maintenanceId,
        @required maintenanceName,
        @required maintenanceMileageLimit,
        @required maintenanceMonthLimit})
      : super(
    maintenanceId: maintenanceId,
    maintenanceName: maintenanceName,
    maintenanceMileageLimit: maintenanceMileageLimit,
    maintenanceMonthLimit: maintenanceMonthLimit,
  );

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceModelToJson(this);
}