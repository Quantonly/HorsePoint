import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horse_point/widgets/back_heading.dart';
import 'package:horse_point/utils.dart' as utils;

class PrivacySecurityPage extends StatefulWidget {
  final dynamic settings;
  final StreamController<double> controller;

  PrivacySecurityPage({this.settings, this.controller});
  @override
  _PrivacySecurityState createState() => _PrivacySecurityState(this.settings);
}

class _PrivacySecurityState extends State<PrivacySecurityPage> {
  StreamSubscription<double> streamSubscription;
  dynamic settings;
  double sidebarPadding = 60;

  _PrivacySecurityState(this.settings);

  @override
  void initState() {
    super.initState();
    Stream stream = widget.controller.stream;
    sidebarPadding = utils.sidebarOffset;
    
    streamSubscription = stream.listen((value) {
      setState(() {
        sidebarPadding = value;
      });
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          BackHeading(title: 'privacy_security'),
          AnimatedPadding(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.only(right: sidebarPadding),
            child: Column(
              children: [
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}