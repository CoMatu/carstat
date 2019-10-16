import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'part.g.dart';

@JsonSerializable()
class Part extends Equatable {
  final String partId;
  final String partName;
  final String partCode;
  final double partPrice;

  Part(
      {@required this.partId,
        @required this.partName,
        @required this.partCode,
        @required this.partPrice});

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
  Map<String, dynamic> toJson() => _$PartToJson(this);

  @override
  List<Object> get props => [partId, partName, partCode, partPrice,];
}