import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:async";

import 'package:provider/provider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:toast/toast.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/utils.dart' as utils;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _registering = false;

  void register() async {
    setState(() {
      _registering = !_registering;
    });
    await new Future.delayed(const Duration(milliseconds: 500));
    context
        .read<AuthenticationService>()
        .signUp(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
        .then((res) => {
              if (res['error'] != null)
                {
                  Toast.show(AppLocalizations.of(context).translate(res['error']), context,
                      duration: Toast.LENGTH_LONG,
                      backgroundColor: Colors.red,
                      gravity: Toast.TOP),
                }
              else if (res['success'] != null)
                {
                  Toast.show(AppLocalizations.of(context).translate(res['success']), context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.TOP),
                  Navigator.pop(context, emailController.text.trim())
                },
              setState(() {
                _registering = !_registering;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        OverlayContainer(
          show: _registering,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.7),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitCubeGrid(
                    color: Colors.white,
                    size: 50.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('creating_account'),
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: utils.primaryColor,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10, left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 0,
                child: Icon(Icons.arrow_back_ios_outlined),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  foregroundDecoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login_background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height * 0.33,
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -69.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Arc(
                                arcType: ArcType.CONVEX,
                                edge: Edge.TOP,
                                height: 70.0,
                                child: Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  color: utils.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('sign_up'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextFormField(
                                controller: firstNameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: utils.getTextFieldDecoration(
                                    AppLocalizations.of(context)
                                        .translate('first_name')),
                                validator: RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate('first_name_required')),
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: TextFormField(
                                controller: lastNameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: utils.getTextFieldDecoration(
                                    AppLocalizations.of(context)
                                        .translate('last_name')),
                                validator: RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate('last_name_required')),
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextFormField(
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
                                          .translate('invalid_email')),
                                ]),
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                  color: Colors.white,
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
                              ),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: utils.getTextFieldDecoration(
                                    AppLocalizations.of(context)
                                        .translate('confirm_password')),
                                validator: (val) => MatchValidator(
                                        errorText: AppLocalizations.of(context)
                                            .translate('password_dont_match'))
                                    .validateMatch(
                                        val, passwordController.text),
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            register();
                          }
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate('sign_up'),
                              style: TextStyle(
                                color: Colors.black,
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
        )
      ],
    );
  }
}
