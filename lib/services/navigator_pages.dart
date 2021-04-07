import 'package:flutter/cupertino.dart';

enum Pages {
  home,
  my_horses,
  add_new_horse,
  settings,
  profile,
  change_password,
  change_email,
  language,
  currency,
  privacy_security
}

Map<Pages, Widget> fragments = {
  Pages.home: Container(),
  Pages.my_horses: Container(),
  Pages.add_new_horse: Container(),
  Pages.settings: Container(),
  Pages.profile: Container(),
  Pages.change_password: Container(),
  Pages.change_email: Container(),
  Pages.language: Container(),
  Pages.currency: Container(),
  Pages.privacy_security: Container(),
};
