import 'package:carstat/components/charts/DonutPieChart.dart';
import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatelessWidget {

//  final PieDataService pieDataService = PieDataService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: DonutPieChart.withSampleData(),
    );
  }

}