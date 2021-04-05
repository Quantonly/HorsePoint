import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';

class MyHorsesPage extends StatefulWidget {
  final double sideBarPadding;
  final VoidCallback onSideBar;

  MyHorsesPage({this.sideBarPadding, this.onSideBar});
  @override
  _MyHorsesState createState() => _MyHorsesState();
}

class _MyHorsesState extends State<MyHorsesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: 60,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  widget.onSideBar();
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.menu)),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  AppLocalizations.of(context).translate('my_horses'),
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
