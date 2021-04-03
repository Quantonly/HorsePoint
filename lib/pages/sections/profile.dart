import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onSideBar;
  ProfilePage({this.onSideBar});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
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
                  "Profile",
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
