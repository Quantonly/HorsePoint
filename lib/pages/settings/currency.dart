import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:horse_point/services/converters/currency_converter.dart';
import 'package:horse_point/utils.dart' as utils;

class CurrencyPage extends StatefulWidget {
  final dynamic settings;
  final Function(String, String, String) onPageChange;

  CurrencyPage({this.settings, this.onPageChange});
  @override
  _CurrencyState createState() => _CurrencyState(this.settings);
}

class _CurrencyState extends State<CurrencyPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  dynamic settings;
  String currency;

  _CurrencyState(this.settings);

  void changeCurrency(newCurrency) {
    setState(() {
      currency = newCurrency;
    });
  }

  void saveCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserService(uid: _firebaseAuth.currentUser.uid).setSettings(widget.settings['language'], currency, widget.settings['notifications']);
    await prefs.setString('currency', currency);
    widget.onPageChange('menu', 'settings', currency);
  }

  @override
  void initState() {
    super.initState();
    currency = widget.settings['currency'];
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
            child: Text(AppLocalizations.of(context).translate('currencies')),
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
                itemCount: CurrencyConverter().currencies.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (currency == CurrencyConverter().currencies[index])
                        ListTile(
                          title: Text('${CurrencyConverter().fullNames[index]}'),
                          subtitle: Text('${CurrencyConverter().currencies[index]}'),
                          trailing: Icon(Icons.check),
                          onTap: () {},
                        ),
                      if (currency != CurrencyConverter().currencies[index])
                        ListTile(
                          title: Text('${CurrencyConverter().fullNames[index]}'),
                          subtitle: Text('${CurrencyConverter().currencies[index]}'),
                          onTap: () {
                            changeCurrency(CurrencyConverter().currencies[index]);
                          },
                        ),
                      if (index != CurrencyConverter().currencies.length - 1)
                        _buildDivider()
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        if (currency != widget.settings['currency'])
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: GestureDetector(
              onTap: () {
                saveCurrency();
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
                    AppLocalizations.of(context).translate('apply'),
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
