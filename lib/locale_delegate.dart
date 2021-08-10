import 'dart:developer';

import 'package:flutter/material.dart';

import 'generated/locale_base.dart';
import 'util/utility/global_var.dart';

class LocalDelegate extends LocalizationsDelegate<LocaleBase> {
  const LocalDelegate();
  static const idMap = const {
    'en': 'locales/en.json',
    'ar': 'locales/ar.json',
    'tr': 'locales/tr.json',
  };

  // List all of the app's supported locales here
  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('tr'),
  ];

  @override
  bool isSupported(Locale locale) => ['en', 'ar', 'tr'].contains(locale.languageCode);

  @override
  Future<LocaleBase> load(Locale locale) async {
    var lang = 'ar';
    if (isSupported(locale)) lang = locale.languageCode;
    final loc = LocaleBase();
    try {
      await loc.load(idMap[lang]);
    } catch (err) {
      log(err.toString());
      lang = 'ar';
      await loc.load(idMap[lang]);
    }
    GlobalVar.initializationLanguage = lang;
    return loc;
  }

  @override
  bool shouldReload(LocalDelegate old) => true;
}
