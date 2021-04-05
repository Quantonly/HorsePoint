import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horse_point/main.dart';

import 'package:horse_point/utils.dart' as utils;

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStartedPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: utils.primaryColor,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AuthenticationWrapper()));
          },
          child: Center(
            child: Text('Dashboard', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
