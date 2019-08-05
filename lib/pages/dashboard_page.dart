import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/pages/add_entry_page.dart';
import 'package:carstat/pages/add_operation_page.dart';
import 'package:carstat/pages/entry_details_page.dart';
import 'package:carstat/services/data_service.dart';
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
    FontAwesomeIcons.tools,
    FontAwesomeIcons.calendarPlus,
  ];

  static List<Entry> _entries = [];

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  //TODO нет обновления после добавления регламента ТО

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.yellow;
    Color foregroundColor = Colors.black87;

    final String carId = ModalRoute.of(context).settings.arguments;

    _getEntries() async {
      _entries = await DataService().getEntries(carId);
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
        body: FutureBuilder(
          future: _getEntries(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            return ListView(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EntryDetailsPage(_entries[index])));
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      leading: CircleAvatar(
                        child: Icon(FontAwesomeIcons.angry),
                        radius: 32.0,
                      ),
                      title: Text(
                        _entries[index].entryName,
                      ),
                      subtitle: Text('Нет информации о проведении ТО'),
                    );
                  },
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[200],
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: Colors.black87,
                    ),
                    radius: 32.0,
                  ),
                  title: Text(
                    'Добро пожаловать в TURBOSTAT!',
                  ),
                  subtitle:
                      Text('Вы используете TURBOSTAT уже 555 дней. Спасибо!'),
                ),
              ],
            );
          },
        ));
  }
}
