import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Text('fff'
/*

      padding: EdgeInsets.all(12),
      child: ListView.builder(
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
                    leading: Image.asset('images/carstat.png'),
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
      ),
*/
    );
  }

  Widget _dialog() {
    return
      Stepper(steps: [
      Step(title: Text('1'), content: Text('dddd')),

    ]);
}
}
