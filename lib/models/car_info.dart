import 'package:carstat/features/turbostat/domain/entities/car.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';


class CarInfo {
  final Car car;
  final List<EntryInfo> entryInfoList;
  CarInfo(this.car, this.entryInfoList);
}

class EntryInfo {
  final Entry entry;
  final List<Operation> entryOperations;
  EntryInfo(this.entry, this.entryOperations);
}