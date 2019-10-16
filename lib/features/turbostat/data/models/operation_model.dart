import 'package:carstat/features/turbostat/domain/entities/operation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'operation_model.g.dart';

@JsonSerializable()
class OperationModel extends Operation {
  OperationModel({
    @required String operationId,
    @required DateTime operationDate,
    @required String maintenanceId,
    @required double operationPrice,
    @required int operationMileage,
    @required String operationNote,
  }) : super(
          operationId: operationId,
          operationDate: operationDate,
          maintenanceId: maintenanceId,
          operationPrice: operationPrice,
          operationMileage: operationMileage,
          operationNote: operationNote,
        );

  factory OperationModel.fromJson(Map<String, dynamic> json) => _$OperationModelFromJson(json);

  Map<String, dynamic> toJson() => _$OperationModelToJson(this);

}
