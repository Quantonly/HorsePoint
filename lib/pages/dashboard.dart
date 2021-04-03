import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:horse_point/pages/sections/home.dart';
import 'package:horse_point/pages/sections/my_horses.dart';
import 'package:horse_point/pages/sections/add_horse.dart';
import 'package:horse_point/pages/sections/settings.dart';
import 'package:horse_point/pages/sections/profile.dart';
import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/widgets/menu_item.dart';
import 'package:horse_point/utils.dart' as utils;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<String> menuItems;
  final List<IconData> menuIcons = [
    CupertinoIcons.home,
    CupertinoIcons.photo,
    CupertinoIcons.add_circled_solid,
    CupertinoIcons.settings
  ];

  bool sidebarOpen = false;

  double yOffset = 0;
  double xOffset = 60;
  double xProfileOffset = 0;
  double yProfileOffset = 0;
  double profileScale = 0;
  double pageScale = 1;
  double buttonsOffset = -100;

  int selectedMenuItem = 0;

  var page;

  void setTranslations() {
    menuItems = [
      AppLocalizations.of(context).translate('home'),
      AppLocalizations.of(context).translate('my_horses'),
      AppLocalizations.of(context).translate('add_new_horse'),
      AppLocalizations.of(context).translate('settings')
    ];
  }

  void setSidebarState() {
    setState(() {
      xOffset = sidebarOpen ? 265 : 60;
      yOffset = sidebarOpen ? 70 : 0;
      pageScale = sidebarOpen ? 0.8 : 1;
      xProfileOffset = sidebarOpen ? 90 : 0;
      yProfileOffset = sidebarOpen ? -25 : 0;
      profileScale = sidebarOpen ? 1.5 : 1;
      buttonsOffset = sidebarOpen ? -20 : -100;
    });
  }

  void setPage() {
    switch (selectedMenuItem) {
      case 0:
        page = HomePage(
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          },
        );
        break;
      case 1:
        page = MyHorsesPage(
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          },
        );
        break;
      case 2:
        page = AddHorsePage(
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          },
        );
        break;
      case 3:
        page = SettingsPage(
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          },
        );
        break;
      default:
        page = ProfilePage(
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          },
        );
        break;
    }
  }

  String truncate(String value, int length) {
    if (value.length > length) return value.substring(0, length) + "...";
    return value;
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

  @override
  void initState() {
    page = HomePage(
      onSideBar: () {
        sidebarOpen = !sidebarOpen;
        setSidebarState();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setTranslations();
    return Scaffold(
      body: Container(
        color: utils.primaryColor,
        child: Container(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx > 1) {
                    sidebarOpen = true;
                    setSidebarState();
                  }
                },
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(
                            xProfileOffset, yProfileOffset, 1.0)
                          ..scale(profileScale),
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 5,
                            bottom: 25),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              sidebarOpen = false;
                              selectedMenuItem = null;
                              setSidebarState();
                              setPage();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                _firebaseAuth.currentUser.photoURL,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width - 265),
                              child: AnimatedOpacity(
                                opacity: sidebarOpen ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  truncate(
                                      _firebaseAuth.currentUser.displayName,
                                      30),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width - 265),
                              child: AnimatedOpacity(
                                opacity: sidebarOpen ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  truncate(_firebaseAuth.currentUser.email, 20),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Expanded(
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(
                                0.0, buttonsOffset, 1.0),
                            child: new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: menuItems.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  sidebarOpen = false;
                                  selectedMenuItem = index;
                                  setSidebarState();
                                  setPage();
                                },
                                child: MenuItem(
                                  itemIcon: menuIcons[index],
                                  itemText: menuItems[index],
                                  selected: selectedMenuItem,
                                  position: index,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            _showSignOutDialog();
                          },
                          child: MenuItem(
                            itemIcon: CupertinoIcons.square_arrow_left,
                            itemText: AppLocalizations.of(context)
                                .translate('sign_out'),
                            selected: selectedMenuItem,
                            position: menuItems.length + 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dx < -1) {
                    sidebarOpen = false;
                    setSidebarState();
                  }
                },
                child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(xOffset, yOffset, 1.0)
                    ..scale(pageScale),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: sidebarOpen
                          ? BorderRadius.circular(20)
                          : BorderRadius.circular(0)),
                  child: page,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
