// запись действия по регламенту ТО. Например, сделана замена масла и фильтра
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'operation.g.dart';

@JsonSerializable()
class Operation extends Equatable {
  final DateTime operationDate;
  final int operationMileage;
  final String operationNote;
  final String maintenanceId;
  final double operationPrice;
  final String operationId;

  Operation({
    @required this.operationId,
    @required this.operationDate,
    @required this.maintenanceId,
    @required this.operationPrice,
    @required this.operationMileage,
    @required this.operationNote,
  });

  @override
  List<Object> get props => [
        operationId,
        operationDate,
        maintenanceId,
        operationPrice,
        operationMileage,
        operationNote,
      ];

  factory Operation.fromJson(Map<String, dynamic> json) => _$OperationFromJson(json);
  Map<String, dynamic> toJson() => _$OperationToJson(this);

}
