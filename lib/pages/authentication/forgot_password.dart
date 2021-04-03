import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:toast/toast.dart';

import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/utils.dart' as utils;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    context
        .read<AuthenticationService>()
        .forgotPassword(
          email: emailController.text.trim(),
        )
        .then((res) => {
              if (res['error'] != null)
                {
                  Toast.show(AppLocalizations.of(context).translate(res['error']), context,
                      duration: Toast.LENGTH_LONG,
                      backgroundColor: Colors.red,
                      gravity: Toast.TOP)
                }
              else if (res['success'] != null)
                {
                  Toast.show(AppLocalizations.of(context).translate(res['success']), context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.TOP),
                  Navigator.pop(context, emailController.text.trim())
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        AppLocalizations.of(context)
                            .translate('forgot_password_page'),
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: utils.getTextFieldDecoration(
                            AppLocalizations.of(context).translate('email')),
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
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        resetPassword();
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
                          AppLocalizations.of(context)
                              .translate('reset_password'),
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
    );
  }
}
