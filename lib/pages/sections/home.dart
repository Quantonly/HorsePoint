import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSideBar;
  HomePage({this.onSideBar});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
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
                  "Homepage",
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
