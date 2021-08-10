import 'dart:convert';
import 'dart:developer';

import '../../ui/pages/account/forget_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/authorization.dart';
import '../../util/utility/api_provider.dart';
import '../../util/utility/global_var.dart';
import '../models/user.dart';

// test user :
// user@elajkom.kuarkz.com
// P@ssw0rd

class UserProvider extends ChangeNotifier {
  User _user;
  Authorization _authorization;

  User get user => _user;
  set user(User user) {
    _user = user;
    notifyListeners();
  }

  void notifyListenersFunc() => notifyListeners();

  bool isLogin() {
    bool isLogin = false;
    if (ApiProvider.accessToken != null && ApiProvider.accessToken.isNotEmpty && _user != null) {
      isLogin = true;
    }
    return isLogin;
  }

  Future<void> getAuthorizationData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(GlobalVar.authorizationKey)) {
        final authorizationData = json.decode(prefs.getString(GlobalVar.authorizationKey)) as Map<String, Object>;
        _authorization = Authorization.fromJson(authorizationData);
        ApiProvider.accessToken = _authorization.accessToken;
      }
    } catch (error) {
      rethrow;
    }
  }

  void saveAuthorizationData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(GlobalVar.authorizationKey, json.encode(data));
  }

  Future<void> checkAuthorization(BuildContext context) async {
    await getAuthorizationData();
    try {
      if (_authorization != null && _authorization.accessToken.isNotEmpty) {
        Duration diff = DateTime.parse(_authorization.expiresIn).difference(DateTime.now());
        // log('///////// _authorization.expiresIn : ${_authorization.expiresIn} ');
        // log('///////// diff.inMinutes : ${diff.inMinutes} ');
        // check if accessToken is valid more than 10 Minutes
        if (diff.isNegative || diff.inMinutes < 10) {
          log('///////// Request refresh_token ');
          Map<String, String> body = {"grant_type": "refresh_token", "refresh_token": _authorization.refreshToken};
          Map<String, String> headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
          };

          var data = await ApiProvider().postRequest('/connect/token', body, headers: headers);
          //Request refresh_token response comes without refreshToken
          _authorization = Authorization.fromJson(data)..refreshToken = _authorization.refreshToken;
          saveAuthorizationData(_authorization.toJson());
          ApiProvider.accessToken = _authorization.accessToken;
        } else
          ApiProvider.accessToken = _authorization.accessToken;
      }
    } catch (error) {
      logout(context);
      print(error.toString());
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Map<String, String> body = {"grant_type": "password", "username": '$email', "password": '$password', "scope": "offline_access"};
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept-Language': GlobalVar.initializationLanguage ?? '*',
      };

      var data = await ApiProvider().postRequest('/connect/token', body, headers: headers);
      _authorization = Authorization.fromJson(data);
      saveAuthorizationData(_authorization.toJson());
      ApiProvider.accessToken = _authorization.accessToken;
      GlobalVar.cloudMessaging.deleteInstance();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> loginExternalGrandtype(String grantType, String accessToken) async {
    try {
      Map<String, String> body = {"grant_type": grantType, "access_token": accessToken, "scope": "offline_access"};
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept-Language': GlobalVar.initializationLanguage ?? '*',
      };

      var data = await ApiProvider().postRequest('/connect/token', body, headers: headers);
      _authorization = Authorization.fromJson(data);
      saveAuthorizationData(_authorization.toJson());
      ApiProvider.accessToken = _authorization.accessToken;
      GlobalVar.cloudMessaging?.deleteInstance();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> singup(String firstName, String lastName, String email, String phoneNumber, String countryPhoneCode, String password, String birthday,
      int specialtyId, int role) async {
    try {
      Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "countryPhoneCode": countryPhoneCode,
        "birthday": birthday,
        "password": password,
        "confirmPassword": password,
        "specialtyId": specialtyId,
        "role": role,
      };

      await ApiProvider().postRequest('/api/Account', json.encode(body));
      await login(email, password);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateAccount(Map<String, dynamic> body) async {
    await ApiProvider().postRequest('/api/Account/UpdateUser', json.encode(body));
  }

  Future<void> updateLang(String lang) async {
    await ApiProvider().getRequest('/api/Account/SetLang/$lang');
  }

  Future<void> updateUserPassword(String oldPassword, String newPassword, String confirmPassword) async {
    Map<String, String> body = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmPassword": newPassword,
    };
    await ApiProvider().postRequest('/api/Account/ChangePassword', json.encode(body));
  }

  Future<void> setUserPassword(String newPassword, String confirmPassword) async {
    Map<String, String> body = {
      "newPassword": newPassword,
      "confirmPassword": newPassword,
    };
    await ApiProvider().postRequest('/api/Account/SetPassword', json.encode(body));
  }

  Future<void> forgetPassword(String email) async {
    Map<String, String> body = {"email": email};
    await ApiProvider().postRequest('/api/Account/ForgetPassword', json.encode(body));
  }

  Future<void> forgetPasswordPhone(String phoneNumber) async {
    Map<String, String> body = {"phoneNumber": phoneNumber};
    await ApiProvider().postRequest('/api/Account/ForgetPasswordPhone', json.encode(body));
  }

  Future<void> resetPassword(ForgetPasswordMethod method, String value, String code, String newPassword) async {
    String subUrl = ' ';
    Map<String, dynamic> body = {};
    if (method == ForgetPasswordMethod.Email) {
      body['email'] = value;
      subUrl = '/api/Account/ResetPassword';
    } else {
      body['phoneNumber'] = value;
      subUrl = '/api/Account//api/Account/ResetPasswordPhone';
    }
    body['code'] = code;
    body['newPassword'] = newPassword;
    await ApiProvider().postRequest(subUrl, json.encode(body));
  }

  Future<void> logout(BuildContext context) async {
    GlobalVar.cloudMessaging?.deleteInstance();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(GlobalVar.authorizationKey)) {
      prefs.remove(GlobalVar.authorizationKey);
      _user = null;
      _authorization = null;
      ApiProvider.accessToken = null;
    }
    notifyListeners();
  }

  Future<User> loadUserProfile(String userId) async {
    try {
      var res = await ApiProvider().getRequest('/api/Users/$userId');
      return User.fromJson(res);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> blockUser(String userId) async {
    await ApiProvider().getRequest('/api/Users/Block/$userId');
  }

  Future<void> unBlockUser(String userId) async {
    await ApiProvider().getRequest('/api/Users/UnBlock/$userId');
  }

  String getMeetingReminderString(int value) {
    switch (value) {
      case 0:
        return str.app.none;
        break;
      case 10:
        return str.app.tenMin;
        break;
      case 20:
        return str.app.twentyMin;
        break;
      case 40:
        return str.app.fourtyMin;
        break;
      default:
        return str.app.none;
    }
  }
}
