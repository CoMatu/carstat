import 'package:carstat/components/drawer.dart';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/models/car.dart';
import 'package:carstat/models/entry.dart';
import 'package:carstat/models/operation.dart';
import 'package:carstat/models/sorted_tile.dart';
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
  List<SortedTile> _sorted;
  static List _tiles;
  DateTime now;

  String tileMessage;
  Car car;
  String carId;
  SortedTile sortedTile;

  _DashboardPageState(this.car);

  @override
  void initState() {
    now = DateTime.now();
    carId = car.carId;
    super.initState();
  }

  _getEntries(String carId) async {
    _sorted = [];
    _entries = await DataService().getEntries(carId);
    _tiles = await dashboardService.getMarkers(_entries, carId);
    _tiles.forEach((res) {
      List<Operation> _operations = res['operations'];
      Entry _entry = res['entry'];

      sortedTile = SortedTile();
      sortedTile.tileName = _entry.entryName;
      sortedTile.entry = _entry;

      if (_operations.length == 0) {
        iconStatus = IconStatus.NotDeterminate;
        sortedTile.icon = Icon(Icons.help_outline, color: Colors.orange, size: 32.0,);
        sortedTile.infoMessage = S.of(context).dashboard_page_not_determinate_title;
      } else {
        _operations.sort((a, b) {
          return b.operationDate.millisecondsSinceEpoch
              .compareTo(a.operationDate.millisecondsSinceEpoch);
        });
        DateTime lastDate = _operations[0].operationDate;

        _operations.sort((a, b) {
          return b.operationMileage.compareTo(a.operationMileage);
        });
        int lastMileage = _operations[0].operationMileage;
        int mileageFromLast = car.carMileage - lastMileage;

        if (mileageFromLast >= _entry.entryMileageLimit) {
          // проверка на пробег сверх лимита
          iconStatus = IconStatus.Danger;
          sortedTile.icon = Icon(Icons.warning, color: Colors.red, size: 32.0,);
          sortedTile.infoMessage = S
              .of(context)
              .dashboard_page_missed_maintenance(mileageFromLast.toString());
        } else {
          int daysFromLast = now.difference(lastDate).inDays;
          int dayLimit = _entry.entryDateLimit*30;
          if (daysFromLast >= dayLimit) {
            int daysOver = daysFromLast - dayLimit;
            iconStatus = IconStatus.Danger;
            sortedTile.icon = Icon(Icons.warning, color: Colors.red, size: 32.0,);
            sortedTile.infoMessage = S
                .of(context)
                .dashboard_page_missed_maintenance_days(daysOver.toString());
          } else {
            int daysRemain = dayLimit - daysFromLast;
            int mileageRemain = lastMileage + _entry.entryMileageLimit - car.carMileage;
            sortedTile.infoMessage = S.of(context).dashboard_page_maintenance_before(
                daysRemain.toString(), mileageRemain.toString());

            if (daysRemain <= 30) {
              iconStatus = IconStatus.Warning;
              sortedTile.icon = Icon(Icons.assignment_late, color: Colors.blue[200], size: 32.0,);
            } else {
              iconStatus = IconStatus.Norm;
              sortedTile.icon = Icon(Icons.directions_car, color: Colors.green, size: 32.0,);
            }
          }
        }
      }

      switch(iconStatus) {

        case IconStatus.Danger:
          sortedTile.rank = 1;
          break;
        case IconStatus.Warning:
          sortedTile.rank = 3;
          break;
        case IconStatus.Norm:
          sortedTile.rank = 4;
          break;
        case IconStatus.NotDeterminate:
          sortedTile.rank = 2;
          break;
      }

      _sorted.add(sortedTile);
    });
    _sorted.sort((a, b) => a.rank.compareTo(b.rank));
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow()]
                      ),
                        child: CircularProgressIndicator()),
                  ));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _sorted.length,
                  itemBuilder: (context, index) {
                    iconStatus = IconStatus.Danger;
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EntryDetailsPage(_sorted[index].entry, car)));
                        },
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        leading: CircleAvatar(
                          child: _sorted[index].icon,
                          radius: 32.0,
                        ),
                        title: Text(
                          _sorted[index].tileName,
                        ),
                        subtitle: Text(_sorted[index].infoMessage),
                      ),
                    );
                  },
                );
              },
            ),
            Card(
              child: ListTile(
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
            ),
          ],
        ));
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
