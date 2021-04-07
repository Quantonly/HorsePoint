import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/pages/settings/change_email.dart';
import 'package:horse_point/pages/settings/change_password.dart';
import 'package:horse_point/pages/settings/currency.dart';
import 'package:horse_point/pages/settings/language.dart';
import 'package:horse_point/pages/settings/privacy_security.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/converters/currency_converter.dart';
import 'package:horse_point/services/converters/language_converter.dart';
import 'package:horse_point/services/navigator_pages.dart';
import 'package:horse_point/services/user.dart';

import 'package:horse_point/widgets/menu_heading.dart';
import 'package:horse_point/utils.dart' as utils;

class SettingsPage extends StatefulWidget {
  final dynamic settings;
  final StreamController<double> controller;
  final VoidCallback onSideBar;

  SettingsPage({this.settings, this.controller, this.onSideBar});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<double> streamSubscription;
  double sidebarPadding = 60;
  var newSettings = {'notifications': true};

  void saveSettings(newSettings) async {
    widget.settings['notifications'] = newSettings['notifications'];
    UserService(uid: _firebaseAuth.currentUser.uid).setSettings(
        widget.settings['language'],
        widget.settings['currency'],
        newSettings['notifications']);
  }

  Widget getPasswordWidgets() {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            CupertinoIcons.lock,
            color: utils.primaryColorLight,
          ),
          title:
              Text(AppLocalizations.of(context).translate('change_password')),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.of(context).pushNamed('/settings/change_password');
          },
        ),
        _buildDivider(),
        ListTile(
          leading: Icon(
            CupertinoIcons.envelope,
            color: utils.primaryColorLight,
          ),
          title: Text(AppLocalizations.of(context).translate('change_email')),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.of(context).pushNamed('/settings/change_email');
          },
        ),
        _buildDivider(),
      ],
    );
  }

  void setPages() {
    fragments.update(
      Pages.change_password,
      (value) => ChangePasswordPage(
        settings: widget.settings,
        controller: widget.controller,
      ),
    );
    fragments.update(
      Pages.change_email,
      (value) => ChangeEmailPage(
        settings: widget.settings,
        controller: widget.controller,
      ),
    );
    fragments.update(
      Pages.language,
      (value) => LanguagePage(
          settings: widget.settings,
          controller: widget.controller,
          onApply: (newLanguage) {
            setState(() {}); //Page refresh
            if (newLanguage != null) widget.settings['language'] = newLanguage;
          }),
    );
    fragments.update(
      Pages.currency,
      (value) => CurrencyPage(
          settings: widget.settings,
          controller: widget.controller,
          onApply: (newCurrency) {
            setState(() {}); //Page refresh
            if (newCurrency != null) widget.settings['currency'] = newCurrency;
          }),
    );
    fragments.update(
      Pages.privacy_security,
      (value) => PrivacySecurityPage(
        settings: widget.settings,
        controller: widget.controller,
      ),
    );
  }

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
    newSettings['notifications'] = widget.settings['notifications'];
    setPages();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    saveSettings(newSettings);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MenuHeading(title: 'settings', onSideBar: widget.onSideBar),
        AnimatedPadding(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.only(right: sidebarPadding),
          child: Column(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('account'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      Card(
                        elevation: 4.0,
                        margin: EdgeInsets.fromLTRB(0, 8.0, 0, 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          children: <Widget>[
                            if (_firebaseAuth
                                    .currentUser.providerData[0].providerId ==
                                'password')
                              getPasswordWidgets(),
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.flag,
                                color: utils.primaryColorLight,
                              ),
                              title: Text(AppLocalizations.of(context)
                                  .translate('language')),
                              subtitle: Text(LanguageConverter()
                                  .getLanguage(widget.settings['language'])),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/settings/language');
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(
                                CurrencyConverter().icons[CurrencyConverter()
                                    .currencies
                                    .indexOf(widget.settings['currency'])],
                                color: utils.primaryColorLight,
                              ),
                              title: Text(AppLocalizations.of(context)
                                  .translate('currency')),
                              subtitle: Text(widget.settings['currency']),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/settings/currency');
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.book,
                                color: utils.primaryColorLight,
                              ),
                              title: Text(AppLocalizations.of(context)
                                  .translate('privacy_security')),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/settings/privacy_security');
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        AppLocalizations.of(context).translate('notifications'),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SwitchListTile(
                        activeColor: utils.primaryColorLight,
                        contentPadding: EdgeInsets.all(0),
                        value: newSettings['notifications'],
                        title: Text(AppLocalizations.of(context)
                            .translate('receive_notifications')),
                        onChanged: (val) {
                          setState(() {
                            newSettings['notifications'] =
                                !newSettings['notifications'];
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
