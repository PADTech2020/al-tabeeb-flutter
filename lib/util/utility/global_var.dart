import '../../classes/providers/user_provider.dart';
import '../../classes/services/cloud_messaging.dart';
import '../../ui/pages/account/login.dart';
import '../../util/custome_widgets/local_notification.dart';
import '../../util/custome_widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../generated/locale_base.dart';
import 'api_provider.dart';

enum ButtonState { Home, Map, Orders, Account, Setting }
enum ItemShowType { List, Grid }
enum CobonShowType { List, Map }
enum ContentPageType { PrivacyPolicy, About, PaymentPolicy }

LocaleBase str;
ThemeData theme;

class GlobalVar {
  static String initializationLanguage;
  static CloudMessaging cloudMessaging;
  static LocalNotification localNotification;

  static const String GOOGLE_API_KEY = "AIzaSyAp9HzSnfyp3c1mSKtOGANwhmFSGa3Rm20";

  static const String currencyTurkey = " ₺ ";
  static const String appCurrency = currencyTurkey;

  ////////////{ Assets Variable}
  static const String assetSvgBase = "assets/svgs/";
  static const String assetsImageBase = "assets/images/";
  static const String logoUrl = "logo.png";
  static const String logo = assetsImageBase + "logo.png";
  static const String logoLand = assetsImageBase + "logo.png";
  static const String noImage = assetsImageBase + "no_image_available.png";
  static const String person = assetsImageBase + "person.png";
  static const String no_data_available = assetsImageBase + "no_data_available.png";
  static const String splashScreen = assetsImageBase + "splash_screen.jpeg";

  ////////////{ SharedPreferences Keys}
  static const String authorizationKey = 'authorizationData';
  static const String langKey = 'languageData';

  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> videoExtensions = ['3gp', 'mp4', 'mkv', 'ts', 'webm', 'mov', 'm4v'];

  ////////////{ Methods}

  static bool isLogin(BuildContext context, {bool showAlertDialog = true}) {
    if (Provider.of<UserProvider>(context, listen: false).isLogin()) {
      return true;
    } else {
      if (showAlertDialog)
        showDialog(
          builder: (context) => CustomDialog(
            title: str.msg.loginFirst,
            actions: <Widget>[
              TextButton(
                child: Text(str.formAndAction.logIn),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(LoginPage.routeName);
                },
              ),
              TextButton(
                child: Text(str.main.later),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          context: context,
        );
      return false;
    }
  }

  static String getAssetsImage(String imageName) => "assets/images/$imageName";

  static String getImageUrl(String subUrl, {int width = 300, int height = 200, bool crop = true}) =>
      ApiProvider.imageApi + GlobalVar.getString(subUrl, GlobalVar.logoUrl) + '?w=$width&h=$height&crop=$crop';
  // GlobalVar.getString(subUrl, GlobalVar.logoUrl);

  static String getDownloadUrl(String subUrl) => ApiProvider.downloadApi + GlobalVar.getString(subUrl);

  static String getString(String string, [String defultValue]) => string ?? defultValue;

  static String numToString(dynamic value, [String defultValue = '0']) => value != null ? value.toString() : defultValue;
  static String doubleToString(dynamic value, [String defultValue = '0']) => value != null ? value.toStringAsFixed(2) : defultValue;

  static String dateForamt(dynamic date, [String foramt = 'd-M-y']) {
    DateTime temp;
    if (date is String)
      temp = DateTime.tryParse(date);
    else
      temp = date;
    if (temp != null)
      return DateFormat(foramt).format(temp.toLocal());
    else
      return null;
  }

  static String timeAgo(String date, [String locale]) {
    if (locale == null) locale = initializationLanguage;
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    return timeago.format(DateTime.parse(date ?? DateTime.now().subtract(Duration(days: 20)).toIso8601String()).toLocal(), locale: locale);
  }

  static dynamic getFirstListItem(List list) => list != null && list.length > 0 ? list.first : null;
  static bool checkLisIsNotEmpty(List list) => list != null && list.length > 0;

  static const String emailRegExp =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static const String phoneRegExp = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';

  static String emailValidation(String email, bool requird) {
    RegExp regExp = RegExp(emailRegExp);
    if (email.isEmpty) {
      if (requird) return str.msg.enterEmail;
    } else {
      if (!regExp.hasMatch(email)) return str.msg.invalidEmail;
    }
    return null;
  }

  static String phoneValidation(String phone, bool requird) {
    RegExp regExp = RegExp(phoneRegExp);
    if (phone.isEmpty) {
      if (requird) return str.msg.enterPhone;
    } else {
      if (!regExp.hasMatch(phone)) return str.msg.invalidPhone;
    }
    return null;
  }
}
