import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Function(String, String) onPageChange;

  ProfilePage({this.onPageChange});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
