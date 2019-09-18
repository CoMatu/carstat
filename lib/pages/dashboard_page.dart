import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/pages/add_entry_page.dart';
import 'package:carstat/pages/add_operation_page.dart';
import 'package:carstat/pages/entry_details_page.dart';
import 'package:carstat/services/dashboard_service.dart';
import 'package:carstat/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IconStatus { Danger, Warning, Norm, NotDeterminate }

class DashboardPage extends StatefulWidget {
  DashboardPage(this.car, {this.onSignedOut});

  final Car car;
  final VoidCallback onSignedOut;

  @override
  _DashboardPageState createState() => _DashboardPageState(car);
}

class _DashboardPageState extends State<DashboardPage> {
  IconStatus iconStatus;
  static const List<IconData> icons = const [
    FontAwesomeIcons.tools,
    FontAwesomeIcons.calendarPlus,
  ];
  DashboardService dashboardService = DashboardService();
  List<Entry> _entries = [];
  static var _tiles;
  var now = DateTime.now();

  String tileMessage;
  Car car;
  String carId;

  _DashboardPageState(this.car);

  @override
  void initState() {
    carId = car.carId;
    super.initState();
  }

  _getEntries(String carId) async {
    _entries = await DataService().getEntries(carId);
    _tiles = await dashboardService.getMarkers(_entries, carId);
  }

  @override
  Widget build(BuildContext context) {
//    Car car = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        drawer: MainDrawer(),
//        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _modalBottomSheet(context, car);
          },
          child: Icon(Icons.add),
        ),
        appBar: MainAppBar(),

/*
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 75,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

*/
/*
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0),
                    icon: Icon(Icons.home),
                    onPressed: () {
                      setState(() {
//                      _myPage.jumpToPage(0);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(right: 28.0),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
//                      _myPage.jumpToPage(1);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0),
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      setState(() {
//                      _myPage.jumpToPage(2);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(right: 28.0),
                    icon: Icon(Icons.list),
                    onPressed: () {
                      setState(() {
//                      _myPage.jumpToPage(3);
                      });
                    },
                  )
*/ /*
                ],
              ),
            ),
          ),
*/

        body: ListView(
          children: <Widget>[
            FutureBuilder(
              future: _getEntries(carId),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 35.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _tiles.length,
                  itemBuilder: (context, index) {
                    iconStatus = IconStatus.Danger;
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EntryDetailsPage(_tiles[index], car)));
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      leading: _iconSet(_tiles[index], _entries[index], car),
                      title: Text(
                        _tiles[index]['entry'].entryName,
                      ),
                      subtitle: Text(tileMessage),
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
                  color: Colors.white,
                  size: 32.0,
                ),
                radius: 32.0,
              ),
              title: Text(
                S.of(context).dashboard_page_welcome,
              ),
              subtitle: Text(S.of(context).dashboard_page_welcome_thanks),
            ),
          ],
        ));
  }

  _iconSet(til, Entry ent, Car car) {
    List<Operation> _tiles = til['operations'];
    DateTime lastDate;
    int dayLimit = ent.entryDateLimit * 30;
    int daysFromLast; // прошло дней с последнего ТО
    int daysOver; // на сколько дней пропустили ТО
    int daysRemain; // осталось дней до следующего ТО
    int lastMileage; // пробег на дату последнего ТО
    int mileageFromLast; // пробег с момента последнего ТО
    int mileageRemain; //
    tileMessage = '';

    if (_tiles.length == 0) {
      iconStatus = IconStatus.NotDeterminate;
      tileMessage = S.of(context).dashboard_page_not_determinate_title;
    } else {
      _tiles.sort((a, b) {
        return b.operationDate.millisecondsSinceEpoch
            .compareTo(a.operationDate.millisecondsSinceEpoch);
      });
      lastDate = _tiles[0].operationDate;

      _tiles.sort((a, b) {
        return b.operationMileage.compareTo(a.operationMileage);
      });
      lastMileage = _tiles[0].operationMileage;
      mileageFromLast = car.carMileage - lastMileage;

      if (mileageFromLast >= ent.entryMileageLimit) {
        // проверка на пробег сверх лимита
        iconStatus = IconStatus.Danger;
        tileMessage = S
            .of(context)
            .dashboard_page_missed_maintenance(mileageFromLast.toString());
      } else {
        daysFromLast = now.difference(lastDate).inDays;
        if (daysFromLast >= dayLimit) {
          daysOver = daysFromLast - dayLimit;
          iconStatus = IconStatus.Danger;
          tileMessage = S
              .of(context)
              .dashboard_page_missed_maintenance_days(daysOver.toString());
        } else {
          daysRemain = dayLimit - daysFromLast;
          mileageRemain = lastMileage + ent.entryMileageLimit - car.carMileage;
          tileMessage = S.of(context).dashboard_page_maintenance_before(
              daysRemain.toString(), mileageRemain.toString());

          if (daysRemain <= 30) {
            iconStatus = IconStatus.Warning;
          } else {
            iconStatus = IconStatus.Norm;
          }
        }
      }
    }

    switch (iconStatus) {
      case IconStatus.NotDeterminate:
        return CircleAvatar(
          child: Icon(
            Icons.help_outline,
            color: Colors.orange,
            size: 32.0,
          ),
          radius: 32.0,
        );
      case IconStatus.Danger:
        return CircleAvatar(
          child: Icon(
            Icons.warning,
            color: Colors.red,
            size: 32.0,
          ),
          radius: 32.0,
        );
        break;
      case IconStatus.Warning:
        return CircleAvatar(
          child: Icon(
            Icons.assignment_late,
            color: Colors.blue,
            size: 32.0,
          ),
          radius: 32.0,
        );
        break;
      case IconStatus.Norm:
        return CircleAvatar(
          child: Icon(
            Icons.directions_car,
            color: Colors.green,
            size: 32.0,
          ),
          radius: 32.0,
        );
        break;
    }
  }

  _modalBottomSheet(context, Car car) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20))),
              child: Wrap(
                children: <Widget>[
                  Container(
                    height: 20.0,
                  ),
                  ListTile(
                    title: Text(S.of(context).add_maintenance_regular),
                    leading: Icon(FontAwesomeIcons.calendarPlus),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEntryPage(car.carId)));
                    },
                  ),
                  ListTile(
                    title: Text(S.of(context).add_maintenance_operation),
                    leading: Icon(FontAwesomeIcons.tools),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddOperationPage(car, _entries)));
                    },
                  ),
                  ListTile(
                    title: Text(S.of(context).button_cancel),
                    leading: Icon(FontAwesomeIcons.arrowLeft),
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(
                    height: 10.0,
                  )
                ],
              ),
            ),
          );
        });
  }
}
