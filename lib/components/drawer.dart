import 'package:carstat/pages/add_car_page.dart';
import 'package:carstat/pages/carslist_page.dart';
import 'package:carstat/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({this.onSignedOut});

  final VoidCallback onSignedOut;
  static BaseAuth auth;

  Future<void> _signOut(BuildContext context) async {
    try {
      await auth.signOut();
      StartPage();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = AuthProvider.of(context).auth;
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(accountName: null, accountEmail: null,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/road.jpg'),
                    fit: BoxFit.fitWidth
                  )
                ),),
                ListTile(
                  title: Text('Мои автомобили'),
                  trailing: Icon(Icons.directions_car),
                  onTap: () async {
                    Navigator.of(context).pop();
                    var user = await auth.currentUser();
                    if (user != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CarsListPage()));
                    }
                  },
                ),
                ListTile(
                  title: Text('Добавить автомобиль'),
                  trailing: Icon(
                    Icons.add,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    var user = await auth.currentUser();
                    if (user != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddCarPage()));
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                        title: Text('Выход из аккаунта'),
                        trailing: Icon(Icons.exit_to_app),
                        onTap: () async {
                          await _signOut(context);
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, 'start_page');
                        }),
                  ],
                ),
              ),
            ),
          )

        ],
      )
    );
  }
}
