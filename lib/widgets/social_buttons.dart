import 'package:flutter/material.dart';
import 'package:horse_point/services/app_localizations.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback onFacebookSignIn;
  final VoidCallback onGoogleSignIn;

  SocialButtons({
    this.onFacebookSignIn,
    this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onFacebookSignIn();
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(58, 87, 156, 1),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      color: Color.fromRGBO(65, 96, 171, 1),
                    ),
                    width: 60,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        "assets/logos/facebook_logo.png",
                        height: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).translate('sign_in_facebook'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onGoogleSignIn();
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(217, 83, 79, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      color: Color.fromRGBO(230, 105, 101, 1),
                    ),
                    width: 60,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        "assets/logos/google_logo.png",
                        height: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).translate('sign_in_google'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
