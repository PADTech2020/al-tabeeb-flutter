import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  static const String fontFamily = 'Tajawal';

  static const primaryColor = Color(0xFF245EB1);

  static const primaryColorDark = Color(0xFF1450b4);
  static const primaryColorLight = Color(0xFF1450b4);

  static const accentColor = Color(0xFF11B2C2);
  static const mainPageBackground = Color(0xFFFAFAFA);
  static const cardBackground = Color(0xffffffff);
  static const greyBackground = Color(0xFFFAFAFA);
  static const greyDarkBackground = Color(0xFFEEEEEE);
  static const redColor = Color(0xFFdc3545);

  static const standardPadding = const EdgeInsets.all(16);

  static const boxShadow = [BoxShadow(blurRadius: 22, color: Colors.black12, offset: Offset(0, 6))];

  static const TextButtonTextStyle1 = TextStyle(
    color: accentColor,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const title1 = TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: fontFamily);
  static const title2 = TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: fontFamily);
  static const title3 = TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: fontFamily);

  static const body1 = TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: fontFamily);
  static const body2 = TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: fontFamily);
  static const body3 = TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: fontFamily);

  static const commentTitle = TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: fontFamily);
  static const commentText = TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: fontFamily);
  static const replyCommentTitle = TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: fontFamily);
  static const replyCommentText = TextStyle(fontSize: 13.0, color: Colors.black, fontFamily: fontFamily);

  static const caption = TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.w500, fontFamily: fontFamily);

  static const numberStyle = TextStyle(fontSize: 13.0, color: Colors.black, fontFamily: 'NumberFont');

  static void setstatusBarColor({Color color = cardBackground, Brightness brightness}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: brightness != null ? brightness : Brightness.dark,
    ));
  }

  static mainThemeData(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      accentColor: accentColor,
      scaffoldBackgroundColor: mainPageBackground,
      primaryIconTheme: IconThemeData(color: Colors.white),
      fontFamily: fontFamily,
      textTheme: TextTheme(
        button: TextStyle(fontWeight: FontWeight.w600),
        headline6: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
      ),
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          shadowColor: Colors.black38,
          elevation: 4,
          color: cardBackground,
          clipBehavior: Clip.antiAlias),
      snackBarTheme: SnackBarThemeData(backgroundColor: Colors.black87, elevation: 15),
      buttonColor: accentColor,
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        textTheme: ButtonTextTheme.primary,
        colorScheme: Theme.of(context).colorScheme.copyWith(primary: accentColor), // highlighted UNColored Button
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: accentColor,
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        ),
      ),
    );
  }
}
