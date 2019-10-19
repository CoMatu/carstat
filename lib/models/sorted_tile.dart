import 'package:carstat/models/entry.dart';
import 'package:flutter/widgets.dart';

class SortedTile {
  String tileName;
  String infoMessage;
  Icon icon;
  int rank;
  Entry entry;

  SortedTile(
      {@required this.entry,
      @required this.tileName,
      @required this.icon,
      @required this.rank,
      @required this.infoMessage});
}
