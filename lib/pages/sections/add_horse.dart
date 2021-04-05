import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';

class AddHorsePage extends StatefulWidget {
  final double sideBarPadding;
  final VoidCallback onSideBar;

  AddHorsePage({this.sideBarPadding, this.onSideBar});
  @override
  _AddHorseState createState() => _AddHorseState();
}

class _AddHorseState extends State<AddHorsePage> {
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
                  AppLocalizations.of(context).translate('add_new_horse'),
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
