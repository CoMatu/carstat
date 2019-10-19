import 'dart:async';

import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/models/sorted_tile.dart';
import 'package:carstat/services/dashboard_service.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';

enum IconStatus { Danger, Warning, Norm, NotDeterminate }

class GetAllSortedTiles {
  DashboardService dashboardService;
  DataService dataService;
  IconStatus iconStatus;
  String tileName;
  Entry entry;
  String infoMessage;
  Icon icon;
  int rank;
  List<SortedTile> _sorted;

  final BuildContext context;
  final Car car;

  GetAllSortedTiles({@required this.context, @required this.car});

  Future<List<SortedTile>> getAllSortedTiles() async{
    dashboardService = DashboardService();
    dataService = DataService();
    DateTime now = DateTime.now();

    final _entries = await dataService.getEntries(car.carId);
    final _tiles = await dashboardService.getMarkers(_entries, car.carId);

    _tiles.forEach((res) {
      List<Operation> _operations = res['operations'];
      Entry _entry = res['entry'];

      tileName = _entry.entryName;
      entry = _entry;

      if (_operations.length == 0) {
        iconStatus = IconStatus.NotDeterminate;
        icon = Icon(
          Icons.help_outline,
          color: Colors.orange,
          size: 32.0,
        );
        infoMessage = S.of(context).dashboard_page_not_determinate_title;
      } else {
        _operations.sort((a, b) {
          return b.operationDate.millisecondsSinceEpoch
              .compareTo(a.operationDate.millisecondsSinceEpoch);
        });
        DateTime lastDate = _operations[0].operationDate;

        _operations.sort((a, b) {
          return b.operationMileage.compareTo(a.operationMileage);
        });
        int lastMileage = _operations[0].operationMileage;
        int mileageFromLast = car.carMileage - lastMileage;

        if (mileageFromLast >= _entry.entryMileageLimit) {
          // проверка на пробег сверх лимита
          iconStatus = IconStatus.Danger;
          icon = Icon(
            Icons.warning,
            color: Colors.red,
            size: 32.0,
          );
          infoMessage = S
              .of(context)
              .dashboard_page_missed_maintenance(mileageFromLast.toString());
        } else {
          int daysFromLast = now.difference(lastDate).inDays;
          int dayLimit = _entry.entryDateLimit * 30;
          if (daysFromLast >= dayLimit) {
            int daysOver = daysFromLast - dayLimit;
            iconStatus = IconStatus.Danger;
            icon = Icon(
              Icons.warning,
              color: Colors.red,
              size: 32.0,
            );
            infoMessage = S
                .of(context)
                .dashboard_page_missed_maintenance_days(daysOver.toString());
          } else {
            int daysRemain = dayLimit - daysFromLast;
            int mileageRemain =
                lastMileage + _entry.entryMileageLimit - car.carMileage;
            infoMessage = S.of(context).dashboard_page_maintenance_before(
                daysRemain.toString(), mileageRemain.toString());

            if (daysRemain <= 30) {
              iconStatus = IconStatus.Warning;
              icon = Icon(
                Icons.assignment_late,
                color: Colors.blue[200],
                size: 32.0,
              );
            } else {
              iconStatus = IconStatus.Norm;
              icon = Icon(
                Icons.directions_car,
                color: Colors.green,
                size: 32.0,
              );
            }
          }
        }
      }

      switch (iconStatus) {
        case IconStatus.Danger:
          rank = 1;
          break;
        case IconStatus.Warning:
          rank = 3;
          break;
        case IconStatus.Norm:
          rank = 4;
          break;
        case IconStatus.NotDeterminate:
          rank = 2;
          break;
      }

      _sorted.add(SortedTile(
        tileName: tileName,
        entry: entry,
        icon: icon,
        infoMessage: infoMessage,
        rank: rank,
      ));
    });


    return _sorted;
}
}