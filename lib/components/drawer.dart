import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';

class MainDrawer extends StatelessWidget {

  MainDrawer({this.onSignedOut});
  final VoidCallback onSignedOut;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          ListTile(
              title: Text('Выход из аккаунта'),
              trailing: Icon(FontAwesomeIcons.signOutAlt),
              onTap: () {
                _signOut(context);
                Navigator.pushNamed(context, 'start_page');
              }),
        ],
      ),
    );
  }
}
