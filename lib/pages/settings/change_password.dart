import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/widgets/back_heading.dart';
import 'package:horse_point/utils.dart' as utils;

class ChangePasswordPage extends StatefulWidget {
  final dynamic settings;
  final StreamController<double> controller;

  ChangePasswordPage({this.settings, this.controller});
  @override
  _ChangePasswordState createState() => _ChangePasswordState(this.settings);
}

class _ChangePasswordState extends State<ChangePasswordPage> {
  StreamSubscription<double> streamSubscription;
  dynamic settings;
  double sidebarPadding = 60;

  _ChangePasswordState(this.settings);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void changePassword() {}

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
          BackHeading(title: 'change_password'),
          Expanded(
            child: AnimatedPadding(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.only(right: sidebarPadding),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: utils.getTextFieldDecoration(
                                  AppLocalizations.of(context)
                                      .translate('old_password')),
                              validator: RequiredValidator(
                                  errorText: AppLocalizations.of(context)
                                      .translate('required_password')),
                              style: new TextStyle(
                                color: Colors.white,
                              ),
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: utils.getTextFieldDecoration(
                                  AppLocalizations.of(context)
                                      .translate('new_password')),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate('required_password')),
                                MinLengthValidator(6,
                                    errorText: AppLocalizations.of(context)
                                        .translate(
                                            'password_least_characters')),
                              ]),
                              style: new TextStyle(
                                color: Colors.white,
                              ),
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: utils.getTextFieldDecoration(
                                  AppLocalizations.of(context)
                                      .translate('confirm_new_password')),
                              validator: (val) => MatchValidator(
                                      errorText: AppLocalizations.of(context)
                                          .translate('password_dont_match'))
                                  .validateMatch(val, passwordController.text),
                              style: new TextStyle(
                                color: Colors.white,
                              ),
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  changePassword();
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: utils.primaryColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('reset_password'),
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
            ),
          ),
        ],
      ),
    );
  }
}
