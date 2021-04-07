import 'package:flutter/material.dart';

Color primaryColor = Color.fromRGBO(33, 44, 54, 1);
Color primaryColorLight = Colors.indigo;
Color secondaryColor = Color(0xFFB151E26);

double sidebarOffset = 60;

InputDecoration getTextFieldDecoration(String label) {
  return InputDecoration(
    labelStyle: TextStyle(
      color: Colors.grey,
    ),
    labelText: label,
    fillColor: Colors.grey,
    contentPadding: EdgeInsets.only(
      left: 30.0,
    ),
    errorStyle: TextStyle(color: Colors.red),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}
