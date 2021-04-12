import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:horse_point/pages/sections/profile.dart';
import 'package:horse_point/pages/sections/home.dart';
import 'package:horse_point/pages/sections/my_horses.dart';
import 'package:horse_point/pages/sections/add_horse.dart';
import 'package:horse_point/pages/settings/settings.dart';

import 'package:horse_point/services/navigator_pages.dart';
import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/user.dart';

import 'package:horse_point/models/menu.dart';
import 'package:horse_point/widgets/menu_item.dart';
import 'package:horse_point/utils.dart' as utils;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  StreamController<double> controller = StreamController<double>.broadcast();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final List<Menu> menuItems = [
    new Menu("home", CupertinoIcons.home),
    new Menu("my_horses", CupertinoIcons.photo),
    new Menu("add_new_horse", CupertinoIcons.add_circled_solid),
    new Menu("settings", CupertinoIcons.settings),
  ];
  var settings;

  String currentRoute = 'home';
  int selectedMenuItem = 0;

  bool sidebarOpen = false;
  double sidebarOffset = 60;
  double yOffset = 0;
  double xOffset = 60;
  double xProfileOffset = 0;
  double yProfileOffset = 0;
  double profileScale = 1;
  double pageScale = 1;
  double buttonsOffset = -75;

  void setSidebarState() {
    setState(() {
      xOffset = sidebarOpen ? 265 : sidebarOffset;
      yOffset = sidebarOpen ? 70 : 0;
      pageScale = sidebarOpen ? 0.8 : 1;
      xProfileOffset = sidebarOpen ? 90 : 0;
      yProfileOffset = sidebarOpen ? -25 : 0;
      profileScale = sidebarOpen ? 1.5 : 1;
      buttonsOffset = sidebarOpen ? 0 : -75;
      sidebarOffset = sidebarOffset;
    });
    controller.add(sidebarOffset);
    utils.sidebarOffset = sidebarOffset;
  }

  void swipeAnimation(details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (sidebarOffset == 0) {
        if (!sidebarOpen) {
          sidebarOffset = 60;
          sidebarOpen = false;
          setSidebarState();
        }
      } else {
        sidebarOpen = true;
        setSidebarState();
      }
    } else if (details.velocity.pixelsPerSecond.dx < 0) {
      if (sidebarOpen)
        sidebarOffset = 60;
      else
        sidebarOffset = 0;
      sidebarOpen = false;
      setSidebarState();
    }
  }

  void getSettings() async {
    await UserService(uid: _firebaseAuth.currentUser.uid)
        .getSettings()
        .then((value) {
      if (value != null) {
        setState(() {
          settings = value['settings'];
        });
        setPages();
      }
    });
  }

  dynamic routeGeneration(settings) {
    dynamic page;
    int durationMilisec = 200;
    int length = settings.name.split('/').length - 1;
    if (settings.name != '/') {
      page = fragments[fragments.keys.firstWhere((element) =>
          describeEnum(element) == settings.name.split('/')[length])];
    } else
      page = HomePage();
    int index = menuItems
        .indexWhere((element) => element.name == settings.name.substring(1));
    if (index > -1) durationMilisec = 0;
    return PageTransition(
        settings: RouteSettings().arguments,
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: durationMilisec),
        reverseDuration: Duration(milliseconds: durationMilisec),
        child: page);
  }

  void setPages() {
    fragments.update(
      Pages.home,
      (value) => HomePage(
          sideBarPadding: sidebarOffset,
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          }),
    );
    fragments.update(
      Pages.my_horses,
      (value) => MyHorsesPage(
          sideBarPadding: sidebarOffset,
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          }),
    );
    fragments.update(
      Pages.add_new_horse,
      (value) => AddHorsePage(
          sideBarPadding: sidebarOffset,
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          }),
    );
    fragments.update(
      Pages.settings,
      (value) => SettingsPage(
          settings: settings,
          controller: controller,
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          }),
    );
    fragments.update(
      Pages.profile,
      (value) => ProfilePage(
          sideBarPadding: sidebarOffset,
          onSideBar: () {
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    getSettings();
    setPages();
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalObjectKey<NavigatorState>(context);
    utils.mainContext = context;
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState.canPop()) navigatorKey.currentState.pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GestureDetector(
              onHorizontalDragEnd: (details) {
                swipeAnimation(details);
              },
              child: Container(
                color: utils.primaryColor,
                child: Column(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      transform: Matrix4.translationValues(
                          xProfileOffset, yProfileOffset, 0)
                        ..scale(profileScale),
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 5,
                          bottom: 25),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (currentRoute != 'profile') {
                              selectedMenuItem = null;
                              currentRoute = 'profile';
                              navigatorKey.currentState.pushNamedAndRemoveUntil(
                                  "/profile", ModalRoute.withName('/'));
                              setSidebarState();
                            } else if (navigatorKey.currentState.canPop()) {
                              navigatorKey.currentState.pushNamedAndRemoveUntil(
                                  "/profile", ModalRoute.withName('/'));
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage(
                              fadeInDuration: Duration(milliseconds: 1),
                              fadeOutDuration: Duration(milliseconds: 1),
                              height: 50,
                              placeholder: AssetImage(
                                  'assets/images/default_profile.png'),
                              image: NetworkImage(
                                _firebaseAuth.currentUser.photoURL,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 146,
                          child: AnimatedOpacity(
                            opacity: sidebarOpen ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  _firebaseAuth.currentUser.displayName,
                                  overflow: TextOverflow.ellipsis,
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
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 146,
                          child: AnimatedOpacity(
                            opacity: sidebarOpen ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  _firebaseAuth.currentUser.email,
                                  overflow: TextOverflow.ellipsis,
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
                    Expanded(
                      child: AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 200),
                        transform: Matrix4.translationValues(
                            0.0, buttonsOffset, 1.0),
                        child: new ListView.builder(
                          padding: EdgeInsets.only(top: 25),
                          physics: BouncingScrollPhysics(),
                          itemCount: menuItems.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              if (menuItems[index].name != currentRoute) {
                                sidebarOpen = false;
                                selectedMenuItem = index;
                                navigatorKey.currentState
                                    .pushNamedAndRemoveUntil(
                                        "/" + menuItems[index].name,
                                        ModalRoute.withName('/'));
                                currentRoute = menuItems[index].name;
                                setSidebarState();
                              } else if (navigatorKey.currentState.canPop()) {
                                navigatorKey.currentState
                                    .pushNamedAndRemoveUntil(
                                        "/" + menuItems[index].name,
                                        ModalRoute.withName('/'));
                              }
                            },
                            child: MenuItem(
                              itemIcon: menuItems[index].icon,
                              itemText: AppLocalizations.of(context)
                                  .translate(menuItems[index].name),
                              selected: selectedMenuItem,
                              position: index,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                swipeAnimation(details);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                transform: Matrix4.translationValues(xOffset, yOffset, 1.0)
                  ..scale(pageScale),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: sidebarOpen
                        ? BorderRadius.circular(20)
                        : BorderRadius.circular(0)),
                child: Navigator(
                  key: navigatorKey,
                  initialRoute: '/home',
                  onGenerateRoute: (settings) {
                    return routeGeneration(settings);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
