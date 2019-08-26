import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carstat/pages/build_waiting_page.dart';
import 'package:carstat/pages/carslist_page.dart';
import 'package:carstat/services/data_service.dart';
import 'package:carstat/pages/login_page.dart';
import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _StartPageState extends State<StartPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;
  String user;
  DataService dataService = DataService();
  Map<PermissionGroup, PermissionStatus> permissions;

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  void getPermission() async {
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.storage,
    ]);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        if (userId != null) {
          user = userId;
        }
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return BuildWaitingPage();
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return buildFutureBuilder();
    }

    return null;
  }

  FutureBuilder<QuerySnapshot> buildFutureBuilder() {
    return FutureBuilder(
      future: dataService.checkUserDocs(user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CarsListPage();
        }
        return BuildWaitingPage();
      },
    );
  }

}
