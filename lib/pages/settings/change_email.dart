import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:toast/toast.dart';

import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/widgets/back_heading.dart';
import 'package:horse_point/utils.dart' as utils;

class ChangeEmailPage extends StatefulWidget {
  final dynamic settings;
  final StreamController<double> controller;

  ChangeEmailPage({this.settings, this.controller});
  @override
  _ChangeEmailState createState() => _ChangeEmailState(this.settings);
}

class _ChangeEmailState extends State<ChangeEmailPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<double> streamSubscription;
  dynamic settings;
  double sidebarPadding = 60;

  _ChangeEmailState(this.settings);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void changeEmail() {
    context
        .read<AuthenticationService>()
        .changeEmail(
            newEmail: emailController.text,
            oldPassword: passwordController.text)
        .then((res) => {
              if (res['error'] != null)
                {
                  Toast.show(
                    AppLocalizations.of(context).translate(res['error']),
                    utils.mainContext,
                    duration: Toast.LENGTH_LONG,
                    backgroundColor: Colors.red,
                    gravity: Toast.TOP,
                  )
                },
              if (res['success'] != null)
                {
                  Toast.show(
                    AppLocalizations.of(context).translate(res['success']),
                    utils.mainContext,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.TOP,
                  ),
                  utils.mainContext.read<AuthenticationService>().signOut()
                }
            });
  }

  Future<void> _showWarningDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('change_email')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)
                    .translate('sure_change_email')),
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
                changeEmail();
              },
            ),
          ],
        );
      },
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
              header: BackHeading(title: 'change_email'),
              content: AnimatedPadding(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(right: sidebarPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: utils.getTextFieldDecoration(
                                  AppLocalizations.of(context)
                                      .translate('email')),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate('email_required')),
                                EmailValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate('invalid_email'))
                              ]),
                              style: new TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  if (emailController.text !=
                                      _firebaseAuth.currentUser.email)
                                    _showWarningDialog();
                                  else {
                                    Toast.show(
                                      AppLocalizations.of(context)
                                          .translate('email_yours'),
                                      utils.mainContext,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundColor: Colors.red,
                                      gravity: Toast.TOP,
                                    );
                                  }
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
                                        .translate('change_email'),
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
}
