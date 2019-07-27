import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/pages/add_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
//    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;

    final String carId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        drawer: MainDrawer(),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(icons.length, (int index) {
            Widget child = Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                  scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(
                    0.0,
                    1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: backgroundColor,
                mini: true,
                child: Icon(icons[index], color: foregroundColor,),
                onPressed: (){},
              ),),
            );
            return child;
          }).toList()..add(FloatingActionButton(
              onPressed: (){
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            heroTag: null,
            child: AnimatedBuilder(animation: _controller,
                builder: (BuildContext context, Widget child) {
              return Transform(
                transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(_controller.isDismissed ? Icons.add : Icons.close),
              );
                }
            ),
          )),
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
                      leading: Icon(
                        FontAwesomeIcons.car,
                        color: Colors.green,
                        size: 44,
                      ),
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
