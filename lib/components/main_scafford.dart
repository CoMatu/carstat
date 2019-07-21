import 'package:carstat/components/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:carstat/components/drawer.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;

  MainScaffold({this.body});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: widget.body,
      drawer: MainDrawer(),
      floatingActionButton: _getFAB(),
    );
  }

  _getFAB() {
    print(widget.body.toString());

    if (widget.body.toString() == 'DashboardPage') {
      return FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus, color: Colors.blue,),
        onPressed: () {},
      );
    }
  }
}
