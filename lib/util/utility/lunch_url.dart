import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

class LunchUrl {
  static Future<bool> canLaunch(String url) async {
    log(url);
    try {
      await launch(url);
      return true;
    } catch (err) {
      log("can't launch : $url");
      return false;
    }
  }
}
