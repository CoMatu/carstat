import 'package:carstat/generated/i18n.dart';
import 'package:carstat/pages/add_car.dart';
import 'package:carstat/pages/carslist_page.dart';
import 'package:carstat/pages/start_page.dart';
import 'package:carstat/pages/statistic_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({this.onSignedOut});

  final VoidCallback onSignedOut;
  static BaseAuth auth;

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  FirebaseUser _firebaseUser;

  Future<void> _signOut(BuildContext context) async {
    try {
      await MainDrawer.auth.signOut();
      StartPage();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        _firebaseUser = user;
      });
    });
    super.initState();
  }

  String _email() {
    if (_firebaseUser != null) {
      return _firebaseUser.email;
    } else {
      return S.of(context).drawer_not_logged;
    }
  }

  @override
  Widget build(BuildContext context) {
    MainDrawer.auth = AuthProvider.of(context).auth;
    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: null,
                accountEmail: Text(_email(),
                    style:
                        const TextStyle(fontSize: 20.0, color: Colors.yellow)),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('images/road.jpg'),
                        fit: BoxFit.fitWidth)),
              ),
              ListTile(
                title: Text(S.of(context).drawer_my_cars),
                trailing: const Icon(Icons.directions_car),
                onTap: () async {
                  Navigator.of(context).pop();
                  var user = await MainDrawer.auth.currentUser();
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarsListPage()));
                  }
                },
              ),
              ListTile(
                title: Text(S.of(context).drawer_add_car),
                trailing: const Icon(
                  Icons.add,
                ),
                onTap: () async {
//                  Navigator.of(context).pop();
                  var user = await MainDrawer.auth.currentUser();
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddCar()));
                  }
                },
              ),
/*
              ListTile(
                title: Text(S.of(context).statistics),
                trailing: const Icon(
                  Icons.pie_chart,
                ),
                onTap: () async {
//                  Navigator.of(context).pop();
                  var user = await MainDrawer.auth.currentUser();
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StatisticPage()));
                  }
                },
              ),
*/
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
                      title: Text(S.of(context).drawer_logout),
                      trailing: const Icon(Icons.exit_to_app),
                      onTap: () async {
                        await _signOut(context);
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, 'start_page');
                      }),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
