import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';

class BackHeading extends StatelessWidget {
  final String title;

  BackHeading({this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 60,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Icon(CupertinoIcons.arrow_left)),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  AppLocalizations.of(context).translate(title),
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
