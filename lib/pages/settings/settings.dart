import 'dart:async';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse_point/services/authentication.dart';
import 'package:sticky_headers/sticky_headers.dart';
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
import 'package:toast/toast.dart';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  void saveSettings(newSettings) async {
    if (_firebaseAuth.currentUser != null) {
      widget.settings['notifications'] = newSettings['notifications'];
      UserService(uid: _firebaseAuth.currentUser.uid).setSettings(
          widget.settings['language'],
          widget.settings['currency'],
          newSettings['notifications']);
    }
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

  Future<void> _showSignOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('sign_out')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context).translate('sure_sign_out')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('no')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('yes')),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthenticationService>().signOut();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                CupertinoIcons.xmark,
                color: Colors.red,
              ),
              SizedBox(width: 10,),
              Text(AppLocalizations.of(context).translate('delete_account')),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)
                    .translate('sure_delete_account')),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: utils.getTextFieldDecoration(
                              AppLocalizations.of(context)
                                  .translate('password')),
                          validator: RequiredValidator(
                              errorText: AppLocalizations.of(context)
                                  .translate('required_password')),
                          style: new TextStyle(
                            color: Colors.black,
                          ),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('no')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('yes')),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  context
                      .read<AuthenticationService>()
                      .deleteAccount(password: passwordController.text)
                      .then((res) => {
                            print(res),
                            if (res['error'] != null)
                              {
                                Toast.show(
                                  AppLocalizations.of(utils.mainContext)
                                      .translate(res['error']),
                                  utils.mainContext,
                                  duration: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.red,
                                  gravity: Toast.TOP,
                                ),
                                passwordController.clear()
                              },
                            if (res['success'] != null)
                              {
                                Navigator.pop(context),
                                context.read<AuthenticationService>().signOut()
                              }
                          });
                }
              },
            ),
          ],
        );
      },
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
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemCount: 1,
          itemBuilder: (context, index) {
            return StickyHeader(
              header: MenuHeading(
                title: 'settings',
                onSideBar: widget.onSideBar,
              ),
              content: AnimatedPadding(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(right: sidebarPadding),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)
                                .translate('application'),
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
                                ListTile(
                                  leading: Icon(
                                    CupertinoIcons.flag,
                                    color: utils.primaryColorLight,
                                  ),
                                  title: Text(AppLocalizations.of(context)
                                      .translate('language')),
                                  subtitle: Text(LanguageConverter()
                                      .getLanguage(
                                          widget.settings['language'])),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/settings/language');
                                  },
                                ),
                                _buildDivider(),
                                ListTile(
                                  leading: Icon(
                                    CurrencyConverter().icons[
                                        CurrencyConverter().currencies.indexOf(
                                            widget.settings['currency'])],
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
                                    Navigator.of(context).pushNamed(
                                        '/settings/privacy_security');
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            AppLocalizations.of(context)
                                .translate('notifications'),
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
                                if (_firebaseAuth.currentUser.providerData[0]
                                        .providerId ==
                                    'password')
                                  getPasswordWidgets(),
                                ListTile(
                                  leading: Icon(
                                    CupertinoIcons.square_arrow_left,
                                    color: utils.primaryColorLight,
                                  ),
                                  title: Text(AppLocalizations.of(context)
                                      .translate('sign_out')),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    _showSignOutDialog();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: GestureDetector(
                              onTap: () {
                                _showDeleteAccountDialog().then(
                                    (value) => passwordController.clear());
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('delete_account'),
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
                  ],
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
