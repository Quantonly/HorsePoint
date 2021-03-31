import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horse_point/pages/authentication/forgot_password.dart';
import 'package:horse_point/pages/authentication/sign_up.dart';

import 'package:provider/provider.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:toast/toast.dart';

import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/widgets/social_buttons.dart';
import 'package:horse_point/utils.dart' as utils;

class SignInPage extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = "";

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Invalid email address'),
    EmailValidator(errorText: 'Invalid email address'),
  ]);

  bool checkValidation() {
    return _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.primaryColor,
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
                        'Sign in',
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
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          controller: emailController,
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
                          decoration: utils.getTextFieldDecoration("Password"),
                          validator: RequiredValidator(
                              errorText: 'Password is required'),
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: true,
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (checkValidation()) {
                        context
                            .read<AuthenticationService>()
                            .signIn(
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
                                          gravity: Toast.TOP)
                                    }
                                  else if (res['success'] != null)
                                    {
                                      // logging in overlay
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
                          "Sign in",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: Text(
                            ' Sign up',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        Text(
                          "  or  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SocialButtons(
                    onFacebookSignIn: () {
                      context
                          .read<AuthenticationService>()
                          .signInFacebook()
                          .then((res) => {
                                if (res['error'] != null)
                                    {
                                      setState(() {
                                        error = res['error'];
                                      }),
                                      Toast.show(error, context,
                                          duration: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.red,
                                          gravity: Toast.TOP)
                                    }
                                else if (res['success'] != null)
                                  {
                                    // logging in overlay
                                  }
                              });
                    },
                    onGoogleSignIn: () {
                      context
                          .read<AuthenticationService>()
                          .signInGoogle()
                          .then((res) => {
                                if (res['error'] != null)
                                    {
                                      setState(() {
                                        error = res['error'];
                                      }),
                                      Toast.show(error, context,
                                          duration: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.red,
                                          gravity: Toast.TOP)
                                    }
                                else if (res['success'] != null)
                                  {
                                    // logging in overlay
                                  }
                              });
                    },
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
