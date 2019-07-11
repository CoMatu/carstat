import 'package:carstat/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

import 'package:carstat/components/drawer.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;

  MainScaffold({this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/carstat.png'),
        centerTitle: true,
      ),
      body: body,
      drawer: MainDrawer(),
      floatingActionButton: _getFAB(),
    );
  }

  _getFAB() {
    print(body);
    if (body != null) {
      return FloatingActionButton(onPressed: null);
    }
  }
}
