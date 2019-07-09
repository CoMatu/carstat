import 'package:carstat/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              //TODO add logout button to menu
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                  color: Colors.yellow[600]
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Image.asset('images/carstat.png'),
        centerTitle: true,
      ),
      body: StartPage(),
    );
  }
}
