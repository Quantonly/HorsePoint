import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/pages/settings/profile.dart';
import 'package:horse_point/pages/settings/currency.dart';
import 'package:horse_point/pages/settings/language.dart';
import 'package:horse_point/pages/settings/settings_options.dart';
import 'package:horse_point/services/user.dart';

import 'package:horse_point/widgets/back_heading.dart';
import 'package:horse_point/widgets/menu_heading.dart';

class SettingsPage extends StatefulWidget {
  final dynamic settings;
  final double sideBarPadding;
  final VoidCallback onSideBar;

  SettingsPage({this.settings, this.sideBarPadding, this.onSideBar});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String heading;
  String page;
  String title = 'settings';

  Widget getHeading() {
    switch (heading) {
      case 'back':
        return BackHeading(
            title: title,
            onPageChange: () {
              setState(() {
                heading = 'menu';
                page = 'settings';
                title = 'Settings';
              });
            });
      default:
        return MenuHeading(title: 'settings', onSideBar: widget.onSideBar);
        break;
    }
  }

  void saveSettings(newSettings) async {
    widget.settings['notifications'] = newSettings['notifications'];
    UserService(uid: _firebaseAuth.currentUser.uid).setSettings(widget.settings['language'], widget.settings['currency'], newSettings['notifications']);
  }

  Widget getPage() {
    switch (page) {
      case 'profile':
        return ProfilePage(onPageChange: (newHeading, newPage) {
          setState(() {
            title = newPage;
            heading = newHeading;
            page = newPage;
          });
        });
        break;
      case 'language':
        return LanguagePage(
            settings: widget.settings,
            onPageChange: (newHeading, newPage, newLanguage) {
              widget.settings['language'] = newLanguage;
              setState(() {
                title = newPage;
                heading = newHeading;
                page = newPage;
              });
            });
        break;
      case 'currency':
        return CurrencyPage(
            settings: widget.settings,
            onPageChange: (newHeading, newPage, newCurrency) {
              widget.settings['currency'] = newCurrency;
              setState(() {
                title = newPage;
                heading = newHeading;
                page = newPage;
              });
            });
        break;
      default:
        return SettingsOptionsPage(
            settings: widget.settings,
            onDestroy: (newSettings) {
              saveSettings(newSettings);
            },
            onPageChange: (newHeading, newPage) {
              setState(() {
                title = newPage;
                heading = newHeading;
                page = newPage;
              });
            });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        getHeading(),
        AnimatedPadding(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.only(right: widget.sideBarPadding),
          child: getPage(),
        ),
      ],
    );
  }
}
