import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    print(body.toString());

    if (body.toString() == 'DashboardPage') {
      return FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus, color: Colors.blue,),
        onPressed: () {},
      );
    }
  }
}
