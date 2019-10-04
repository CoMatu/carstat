import 'package:carstat/components/custom_circle_progress_bar.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:flutter/material.dart';

class BuildWaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        alignment: Alignment.center,
        child: CustomCircleProgressBar(),
      ),
    );
  }

}