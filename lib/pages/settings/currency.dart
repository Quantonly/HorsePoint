import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/user.dart';
import 'package:horse_point/widgets/back_heading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:horse_point/services/converters/currency_converter.dart';
import 'package:horse_point/utils.dart' as utils;
import 'package:sticky_headers/sticky_headers/widget.dart';

class CurrencyPage extends StatefulWidget {
  final dynamic settings;
  final StreamController<double> controller;
  final Function(String) onApply;

  CurrencyPage({this.settings, this.controller, this.onApply});
  @override
  _CurrencyState createState() => _CurrencyState(this.settings);
}

class _CurrencyState extends State<CurrencyPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<double> streamSubscription;
  dynamic settings;
  String currency;
  double sidebarPadding = 60;

  _CurrencyState(this.settings);

  void changeCurrency(newCurrency) {
    setState(() {
      currency = newCurrency;
    });
  }

  void saveCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserService(uid: _firebaseAuth.currentUser.uid).setSettings(
        widget.settings['language'],
        currency,
        widget.settings['notifications']);
    await prefs.setString('currency', currency);
    widget.onApply(currency);
    Navigator.of(context).pop();
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
    currency = widget.settings['currency'];
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
              header: BackHeading(title: 'currency'),
              content: AnimatedPadding(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(right: sidebarPadding),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(AppLocalizations.of(context)
                              .translate('currencies')),
                        ),
                      ),
                      SizedBox(height: 5),
                      Card(
                        elevation: 4.0,
                        margin: EdgeInsets.fromLTRB(0, 8.0, 0, 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 0),
                          shrinkWrap: true,
                          itemCount: CurrencyConverter().currencies.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                if (currency ==
                                    CurrencyConverter().currencies[index])
                                  ListTile(
                                    title: Text(
                                        '${CurrencyConverter().fullNames[index]}'),
                                    subtitle: Text(
                                        '${CurrencyConverter().currencies[index]}'),
                                    trailing: Icon(
                                      Icons.check,
                                      color: utils.primaryColorLight,
                                    ),
                                    onTap: () {},
                                  ),
                                if (currency !=
                                    CurrencyConverter().currencies[index])
                                  ListTile(
                                    title: Text(
                                        '${CurrencyConverter().fullNames[index]}'),
                                    subtitle: Text(
                                        '${CurrencyConverter().currencies[index]}'),
                                    onTap: () {
                                      changeCurrency(CurrencyConverter()
                                          .currencies[index]);
                                    },
                                  ),
                                if (index !=
                                    CurrencyConverter().currencies.length - 1)
                                  _buildDivider()
                              ],
                            );
                          },
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
                                  AppLocalizations.of(context)
                                      .translate('apply'),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
