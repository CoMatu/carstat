import 'package:carstat/components/main_scafford.dart';
import 'package:carstat/pages/start_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Widget body = StartPage();

  @override
  Widget build(BuildContext context) {
    return body;
  }


}