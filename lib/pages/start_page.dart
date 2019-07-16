import 'package:carstat/pages/add_car_page.dart';
import 'package:carstat/pages/build_waiting_page.dart';
import 'package:carstat/components/main_scafford.dart';
import 'package:carstat/pages/carslist_page.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';

import 'package:carstat/pages/dashboard_page.dart';
import 'package:carstat/pages/login_page.dart';
import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        if(userId != null) {
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

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
/*
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return MainScaffold(body: BuildWaitingPage());
      case AuthStatus.notSignedIn:
        return MainScaffold(body: LoginPage(
          onSignedIn: _signedIn,
        ));
      case AuthStatus.signedIn:
        //TODO check users doc is exist
        return MainScaffold(body: CarsListPage(
//            onSignedOut: _signedOut
        ));
    }
*/
    return FutureBuilder(
      future: DataService().checkUsersDoc(user),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.data.documents.length == 0) {
            return MainScaffold(body: AddCarPage(),);
          } else {
            return MainScaffold(body: CarsListPage(),);
          }
        }
        return BuildWaitingPage();
      },
    );
  }
}
