import 'dart:collection';

import 'package:carstat/models/sorted_tile.dart';
import 'package:flutter/material.dart';

class DashboardModel extends ChangeNotifier {
  final List<SortedTile> _list = [];

  UnmodifiableListView<SortedTile> get allSortedTiles =>
      UnmodifiableListView(_list);

  void addSortedTile(SortedTile sortedTile) {
    _list.add(sortedTile);
    notifyListeners();
  }

  void deleteSortedTile(SortedTile sortedTile) {
    _list.remove(sortedTile);
    notifyListeners();
  }
}
