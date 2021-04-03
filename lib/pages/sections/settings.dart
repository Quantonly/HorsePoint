import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onSideBar;
  SettingsPage({this.onSideBar});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
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
                  AppLocalizations.of(context).translate('settings'),
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
