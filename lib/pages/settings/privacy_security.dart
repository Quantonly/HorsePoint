import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horse_point/widgets/back_heading.dart';
import 'package:horse_point/utils.dart' as utils;
import 'package:sticky_headers/sticky_headers/widget.dart';

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
      color: Colors.white,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemCount: 1,
          itemBuilder: (context, index) {
            return StickyHeader(
              header: BackHeading(title: 'privacy_security'),
              content: AnimatedPadding(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(right: sidebarPadding),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
