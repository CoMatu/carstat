import 'package:carstat/features/turbostat/domain/entities/mileage.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mileage_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MileageModel extends Mileage {
  MileageModel({
    @required DateTime entryMileageDate,
    @required int mileage,
  }) : super(
          entryMileageDate: entryMileageDate,
          mileage: mileage,
        );

  factory MileageModel.fromJson(Map<String, dynamic> json) =>
      _$MileageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MileageModelToJson(this);
}
