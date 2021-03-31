import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:toast/toast.dart';

import 'package:horse_point/services/authentication.dart';
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
  String error = "";

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Invalid email address'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  bool checkValidation() {
    return _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.primaryColor,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 10),
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
                        'Sign up',
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                utils.getTextFieldDecoration("First name"),
                            validator: RequiredValidator(
                                errorText: "First name is required"),
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
                            textCapitalization: TextCapitalization.sentences,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                utils.getTextFieldDecoration("Last name"),
                            validator: RequiredValidator(
                                errorText: "Last name is required"),
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
                            decoration: utils.getTextFieldDecoration("Email"),
                            validator: emailValidator,
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
                            decoration:
                                utils.getTextFieldDecoration("Password"),
                            validator: passwordValidator,
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
                            decoration: utils
                                .getTextFieldDecoration("Confirm password"),
                            validator: (val) => MatchValidator(
                                    errorText: 'Passwords do not match')
                                .validateMatch(val, passwordController.text),
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
                      if (checkValidation()) {
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
                                      setState(() {
                                        error = res['error'];
                                      }),
                                      Toast.show(error, context,
                                          duration: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.red,
                                          gravity: Toast.TOP),
                                    }
                                  else if (res['success'] != null)
                                    {
                                      //toast
                                      Navigator.pop(context)
                                    }
                                });
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
                          "Sign up",
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
