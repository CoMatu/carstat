import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('car', style: TextStyle(color: Colors.green, fontSize: 24.0)),
          Text('stat', style: TextStyle(color: Colors.red, fontSize: 24.0),),
        ],
      ),
    );
  }

}