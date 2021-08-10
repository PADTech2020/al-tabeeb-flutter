import 'dart:developer';

import 'package:elajkom/ui/pages/doctors/update_bank_info_page.dart';

import './ui/pages/doctors/update_educational_Section_page.dart';
import './ui/pages/doctors/update_personal_info_page.dart';
import './ui/pages/doctors/update_work_times_page.dart';
import './ui/pages/specialty_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/providers/chat_provider.dart';
import 'classes/providers/initial_data_provider.dart';
import 'classes/providers/notification_provider.dart';
import 'classes/providers/user_provider.dart';
import 'generated/locale_base.dart';
import 'locale_delegate.dart';
import 'ui/pages/account/account_page.dart';
import 'ui/pages/account/forget_password_page.dart';
import 'ui/pages/account/login.dart';
import 'ui/pages/chat/chat_file_picker.dart';
import 'ui/pages/chat/chat_image_picker.dart';
import 'ui/pages/chat/chats_page.dart';
import 'ui/pages/doctors/update_price_table_page.dart';
import 'ui/pages/image_picker_page.dart';
import 'ui/pages/notification_page.dart';
import 'ui/pages/splash_page.dart';
import 'util/utility/custom_theme.dart';
import 'util/utility/global_var.dart';
import 'util/utility/route_generator.dart';

void main(List<String> args) async {
  // WidgetsFlutterBinding.ensureInitialized: Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(GlobalVar.langKey)) {
    GlobalVar.initializationLanguage = prefs.getString(GlobalVar.langKey);
  }
  runApp(
    InitWidget(
      child: MyApp(),
    ),
  );
}

class InitWidget extends StatefulWidget {
  InitWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_InitWidgetState>().restartApp();
  }

  @override
  _InitWidgetState createState() => _InitWidgetState();
}

class _InitWidgetState extends State<InitWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

/////////  { This widget is the root of your application }.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('**************************************** MyApp.build');
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => InitialDataProvider()),
        ChangeNotifierProvider(create: (ctx) => ChatProvider()),
        ChangeNotifierProvider(create: (ctx) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'alTabeeb',

        localizationsDelegates: [
          const LocalDelegate(),
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],

        supportedLocales: LocalDelegate.supportedLocales,
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          if (GlobalVar.initializationLanguage != null && GlobalVar.initializationLanguage.isNotEmpty) {
            Locale initLocal = Locale(GlobalVar.initializationLanguage);
            for (var supportedLocale in supportedLocales) {
              //&& supportedLocale.countryCode == locale.countryCode
              if (supportedLocale.languageCode == initLocal.languageCode) {
                return supportedLocale;
              }
            }
          }
          for (var supportedLocale in supportedLocales) {
            //&& supportedLocale.countryCode == locale.countryCode
            if (supportedLocale.languageCode == locale.languageCode) {
              GlobalVar.initializationLanguage = supportedLocale.languageCode;
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },

        theme: CustomTheme.mainThemeData(context),

        debugShowCheckedModeBanner: false,

        home: SplashPage(),

        // Initially display FirstPage
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          ForgetPasswrodPage.routeName: (ctx) => ForgetPasswrodPage(),
          SpecialtiesPage.routeName: (ctx) => SpecialtiesPage(),
          AccountPage.routeName: (ctx) => AccountPage(),
          ChatsPage.routeName: (ctx) => ChatsPage(),
          ChatImagePickerPage.routeName: (ctx) => ChatImagePickerPage(),
          ChatFilePicher.routeName: (ctx) => ChatFilePicher(),
          ImagePickerPage.routeName: (ctx) => ImagePickerPage(),
          UpdatePersonalInfoPage.routeName: (ctx) => UpdatePersonalInfoPage(),
          UpdateBankInfoPage.routeName: (ctx) => UpdateBankInfoPage(),
          UpdateEducationalSectionPage.routeName: (ctx) => UpdateEducationalSectionPage(),
          UpdatePriceTablePage.routeName: (ctx) => UpdatePriceTablePage(),
          UpdateWorkeTimePage.routeName: (ctx) => UpdateWorkeTimePage(),
          NotificationPage.routeName: (ctx) => NotificationPage(),
        },
      ),
    );
  }
}
