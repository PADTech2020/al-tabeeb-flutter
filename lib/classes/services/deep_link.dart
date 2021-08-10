import 'dart:developer';

import 'package:flutter/material.dart';

import '../../ui/pages/account/forget_password_page.dart';
import '../../ui/pages/account/reset_password_page.dart';

Uri deepKinkUri;

class DeepLink {
  static void uriParse(BuildContext context) {
    if (deepKinkUri != null) {
      log('************************* uriLink?.path : ${deepKinkUri?.path}');
      log('***********************sssss** deepKinkUri?.queryParametersAll : ${deepKinkUri?.queryParametersAll?.toString()}');
      if (deepKinkUri.path == '/ar/auth/reset-password' ||
          deepKinkUri.path == '/en/auth/reset-password' ||
          deepKinkUri.path == '/tr/auth/reset-password') {
        log('************************* 1111111');
        ForgetPasswordMethod method = ForgetPasswordMethod.Email;
        String email = '';
        String emailKey = 'email';
        String code = '';
        String codeKey = 'code';
        if (deepKinkUri.queryParametersAll.containsKey(emailKey) && deepKinkUri.queryParametersAll[emailKey].length > 0) {
          email = deepKinkUri?.queryParametersAll[emailKey][0];
          log('************************* 2222');
        }
        if (deepKinkUri.queryParametersAll.containsKey(codeKey) && deepKinkUri.queryParametersAll[codeKey].length > 0) {
          code = deepKinkUri?.queryParametersAll[codeKey][0];
          log('************************* 333333');
        }

        Navigator.of(context).pushNamed(ResetPasswordPage.routeName, arguments: [method, email, code]);
      }

      deepKinkUri = null;
    }
  }
}
