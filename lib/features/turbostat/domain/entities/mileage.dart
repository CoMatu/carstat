import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'mileage.g.dart';

@JsonSerializable()
class Mileage extends Equatable {
  final DateTime entryMileageDate;
  final int mileage;

  Mileage({
    @required this.entryMileageDate,
    @required this.mileage,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) =>
      _$MileageFromJson(json);

  Map<String, dynamic> toJson() => _$MileageToJson(this);

  @override
  List<Object> get props => null;
}
