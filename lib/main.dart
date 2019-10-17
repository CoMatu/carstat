import 'package:carstat/generated/i18n.dart';
import 'package:carstat/pages/add_car.dart';
import 'package:carstat/pages/dashboard_page.dart';
import 'package:carstat/pages/edit_car_page.dart';
import 'package:carstat/pages/edit_entry_page.dart';
import 'package:carstat/pages/logo_screen.dart';
import 'package:carstat/pages/statistic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:carstat/pages/start_page.dart';
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
        debugShowCheckedModeBanner: false,
        routes: {
          'start_page': (context) => StartPage(),
          'dashboard_page': (context) => DashboardPage(),
          'car_list_page': (context) => CarsListPage(),
          'add_car_page': (context) => AddCar(),
          'edit_car_page': (context) => EditCarPage(),
          'edit_entry_page': (context) => EditEntryPage(),
          'statistic_page': (context) => StatisticPage(),
        },
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'TurboStat',
        theme: ThemeData(
            primarySwatch: Colors.yellow,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            })),
        home: LogoScreen(),
      ),
    );
  }
}
