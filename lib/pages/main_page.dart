import 'package:carstat/pages/start_page.dart';
import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  _MainPageState({this.onSignedOut});
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
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: null),
            ListTile(
              title: Text('Выход из аккаунта'),
              trailing: Icon(FontAwesomeIcons.signOutAlt),
              onTap: () => _signOut(context),
            ),
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
