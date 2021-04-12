import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:horse_point/pages/dashboard.dart';
import 'package:horse_point/pages/authentication/sign_in.dart';

import 'package:horse_point/services/authentication.dart';
import 'package:horse_point/services/app_localizations.dart';
import 'package:horse_point/services/user.dart';

import 'package:horse_point/utils.dart' as utils;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HorsePointApp());
}

class HorsePointApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        supportedLocales: [
          Locale('en'),
          Locale('nl'),
          Locale('fr'),
          Locale('de'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        title: 'Horse Point',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Nunito',
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

Future<dynamic> getRedirect(uid, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var settings;
  await UserService(uid: uid).getSettings().then((value) {
    if (value != null) settings = value['settings'];
  });
  if (settings != null) {
    await prefs.setString('language', settings['language']);
    AppLocalizations.of(context).load(Locale(settings['language']));
  }
  await Future.delayed(Duration(milliseconds: 1000));
  await prefs.setBool('signing_in', false);
  return settings;
}

class RetrievingInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: utils.primaryColor),
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
                        .translate('retrieving_information'),
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      prefs.setBool('signing_in', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      if (firebaseUser.providerData[0].providerId != 'facebook.com' &&
          !firebaseUser.emailVerified) return SignInPage();
      return FutureBuilder(
          future: getRedirect(firebaseUser.uid, context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return DashboardPage();
            }
            if (prefs.getBool('signing_in')) return RetrievingInfo();
            return DashboardPage();
          });
    }
    return SignInPage();
  }
}
