import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:carstat/pages/start_page.dart';
import 'package:carstat/pages/dashboard_page.dart';
import 'package:carstat/pages/carslist_page.dart';
import 'package:carstat/services/auth_provider.dart';
import 'package:carstat/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: AuthService(),
      child: MaterialApp(
        routes: {
          'start_page': (context) => StartPage(),
          'dashboard_page': (context) => DashboardPage(),
          'car_list_page': (context) => CarsListPage()
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ru', 'RU'), // include country code too
        ],
        title: 'carstat',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: StartPage(),
      ),
    );
  }
}