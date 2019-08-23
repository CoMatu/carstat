import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/pages/add_entry_page.dart';
import 'package:carstat/pages/add_operation_page.dart';
import 'package:carstat/pages/entry_details_page.dart';
import 'package:carstat/services/dashboard_service.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

enum IconStatus { Danger, Warning, Norm, NotDeterminate }

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  IconStatus iconStatus = IconStatus.Danger;
  static const List<IconData> icons = const [
    FontAwesomeIcons.tools,
    FontAwesomeIcons.calendarPlus,
  ];
  DashboardService dashboardService = DashboardService();
  static List<Entry> _entries = [];
  static var _tiles;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.yellow;
    Color foregroundColor = Colors.black87;

    final String carId = ModalRoute.of(context).settings.arguments;

    _getEntries() async {
      _entries = await DataService().getEntries(carId);
      _tiles = await dashboardService.getMarkers(_entries, carId);
    }

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
                  curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                      curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: backgroundColor,
                  mini: true,
                  child: Icon(
                    icons[index],
                    color: foregroundColor,
                    size: 18,
                  ),
                  onPressed: () {
                    // выбираем куда переход по индексу в списке иконок icons
                    if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEntryPage(carId)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddOperationPage(carId, _entries)));
                    }
                  },
                ),
              ),
            );
            return child;
          }).toList()
            ..add(FloatingActionButton(
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              heroTag: null,
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform:
                          Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: Icon(
                        _controller.isDismissed
                            ? Icons.add
                            : FontAwesomeIcons.times,
                      ),
                    );
                  }),
            )),
        ),
        appBar: MainAppBar(),
        body: ListView(
          children: <Widget>[
            FutureBuilder(
              future: _getEntries(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 35.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                print('длина списка '+_tiles.length.toString());
                return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: _tiles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EntryDetailsPage(
                                        _tiles[index], carId)));
                          },
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          leading: _iconSet(),
                          title: Text(
                            _tiles[index]['entry'].entryName,
                          ),
                          subtitle: Text('Нет информации о проведении ТО'),
                        );
                      },
                    );
              },
            ),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              leading: CircleAvatar(
                backgroundColor: Colors.blue[200],
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                radius: 32.0,
              ),
              title: Text(
                'Добро пожаловать в TURBOSTAT!',
              ),
              subtitle: Text('Спасибо, что Вы с нами!'),
            ),
          ],
        ));
  }

  _iconSet() {
    switch (iconStatus) {
      case IconStatus.NotDeterminate:
        return CircleAvatar(
          child: Icon(Icons.help_outline),
          radius: 32.0,
        );
      case IconStatus.Danger:
        return CircleAvatar(
          child: Icon(
            Icons.warning,
            color: Colors.red,
          ),
          radius: 32.0,
        );
        break;
      case IconStatus.Warning:
        return CircleAvatar(
          child: Icon(Icons.assignment_late),
          radius: 32.0,
        );
        break;
      case IconStatus.Norm:
        return CircleAvatar(
          child: Icon(Icons.directions_car),
          radius: 32.0,
        );
        break;
    }
  }
}
