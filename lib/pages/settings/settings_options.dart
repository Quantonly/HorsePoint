import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';

import 'package:horse_point/services/language_converter.dart';
import 'package:horse_point/utils.dart' as utils;

class SettingsOptionsPage extends StatefulWidget {
  final dynamic settings;
  final Function(String, String) onPageChange;

  SettingsOptionsPage({this.settings, this.onPageChange});
  @override
  _SettingsOptionsState createState() => _SettingsOptionsState();
}

class _SettingsOptionsState extends State<SettingsOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 4.0,
                  margin: EdgeInsets.fromLTRB(0, 8.0, 0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.profile_circled,
                          color: utils.primaryColorLight,
                        ),
                        title: Text(AppLocalizations.of(context).translate('edit_profile')),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          widget.onPageChange('back', 'profile');
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.flag_circle,
                          color: utils.primaryColorLight,
                        ),
                        title: Text(AppLocalizations.of(context).translate('change_language')),
                        subtitle: Text(LanguageConverter().getLanguage(widget.settings['language'])),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          widget.onPageChange('back', 'language');
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.money_euro_circle,
                          color: utils.primaryColorLight,
                        ),
                        title: Text(AppLocalizations.of(context).translate('change_currency')),
                        subtitle: Text(widget.settings['currency']),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          widget.onPageChange('back', 'currency');
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  AppLocalizations.of(context).translate('notification_settings'),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SwitchListTile(
                  activeColor: utils.primaryColorLight,
                  contentPadding: EdgeInsets.all(0),
                  value: true,
                  title: Text(AppLocalizations.of(context).translate('receive_notifications')),
                  onChanged: (val) {},
                ),
              ],
            ),
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
