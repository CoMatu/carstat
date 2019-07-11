import 'package:carstat/components/build_waiting_screen.dart';
import 'package:carstat/components/main_scafford.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
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
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return MainScaffold(body: BuildWaitingScreen());
      case AuthStatus.notSignedIn:
        return MainScaffold(body: LoginPage(
          onSignedIn: _signedIn,
        ));
      case AuthStatus.signedIn:
        return MainScaffold(body: DashboardPage(
            onSignedOut: _signedOut
        ));
    }
    return null;
  }
}
