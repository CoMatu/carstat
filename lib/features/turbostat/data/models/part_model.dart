import 'package:carstat/features/turbostat/domain/entities/part.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part_model.g.dart';

@JsonSerializable(explicitToJson: true)

class PartModel extends Part {
  PartModel(
      {@required partId,
        @required partName,
        @required partCode,
        @required partPrice})
      : super(
    partId: partId,
    partName: partName,
    partCode: partCode,
    partPrice: partPrice,
  );

  factory PartModel.fromJson(Map<String, dynamic> json) => _$PartModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartModelToJson(this);

}