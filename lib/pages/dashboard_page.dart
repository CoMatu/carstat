import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/pages/add_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    final String carId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        drawer: MainDrawer(),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.green,
            size: 32,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddEntryPage(carId)));
          },
        ),
        appBar: MainAppBar(),
        body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Срочно заменить',
                    style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                  ),
                ),
                Column(
                  children: List.generate(3, (int index) {
                    return ListTile(
                      leading: Icon(FontAwesomeIcons.car, color: Colors.green, size: 44,),
                      title: Text('Моторное масло и фильтр'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Дата замены: '),
                          Text('Пробег, км: '),
                          Text('Марка масла: ')
                        ],
                      ),
                    );
                  }),
                )
              ],
            );
          },
        ));
  }
}
