import 'package:flutter/material.dart';
import 'package:horse_point/utils.dart' as utils;

class MenuItem extends StatelessWidget {
  final String itemText;
  final IconData itemIcon;
  final int selected;
  final int position;
  MenuItem({this.itemText, this.itemIcon, this.selected, this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected == position ? utils.secondaryColor : utils.primaryColor,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Icon(itemIcon, color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              itemText,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}