import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:horse_point/services/language_converter.dart';
import 'package:horse_point/utils.dart' as utils;

class LanguagePage extends StatefulWidget {
  final dynamic settings;
  final Function(String, String, String) onPageChange;

  LanguagePage({this.settings, this.onPageChange});
  @override
  _LanguageState createState() => _LanguageState(this.settings);
}

class _LanguageState extends State<LanguagePage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  dynamic settings;
  String language;

  _LanguageState(this.settings);

  void changeLanguage(newLanguage) {
    setState(() {
      language = newLanguage;
    });
  }

  void saveLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserService(uid: _firebaseAuth.currentUser.uid).setSettings(LanguageConverter().getAbbreviation(language), widget.settings['currency'], widget.settings['notifications']);
    await prefs.setString('language', LanguageConverter().getAbbreviation(language));
    AppLocalizations.of(context).load(Locale(LanguageConverter().getAbbreviation(language)));
    widget.onPageChange('menu', 'settings', LanguageConverter().getAbbreviation(language));
  }

  @override
  void initState() {
    super.initState();
    language = LanguageConverter().getLanguage(widget.settings['language']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 19),
            child: Text(AppLocalizations.of(context).translate('supported_languages')),
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Material(
            color: Colors.white,
            elevation: 1,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                itemCount: LanguageConverter().languages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (language == LanguageConverter().languages[index])
                        ListTile(
                          title: Text('${LanguageConverter().languages[index]}'),
                          trailing: Icon(Icons.check),
                          onTap: () {},
                        ),
                      if (language != LanguageConverter().languages[index])
                        ListTile(
                          title: Text('${LanguageConverter().languages[index]}'),
                          onTap: () {
                            changeLanguage(LanguageConverter().languages[index]);
                          },
                        ),
                      if (index != LanguageConverter().languages.length - 1)
                        _buildDivider()
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        if (language != LanguageConverter().getLanguage(widget.settings['language']))
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: GestureDetector(
              onTap: () {
                saveLanguage();
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: utils.primaryColorLight,
                ),
                child: Center(
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
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
