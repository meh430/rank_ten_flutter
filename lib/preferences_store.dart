import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStore {
  static const DARK_THEME = "DARKTHEME";
  static const JWT_TOKEN = "JWTTOKEN";
  static const USER_NAME_KEY = "USERNAME";
  static const PASSWORD_KEY = "PASSWORD";

  void saveDarkTheme(bool val) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(DARK_THEME, val);
  }

  void saveCred(String token, String un, String pwd) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(JWT_TOKEN, token);
    prefs.setString(USER_NAME_KEY, un);
    prefs.setString(PASSWORD_KEY, pwd);
  }

  Future<bool> isDark() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(DARK_THEME) ?? false;
  }

  Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(JWT_TOKEN) ?? "";
  }

  Future<String> getUserName() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_NAME_KEY) ?? "";
  }

  Future<String> getPwd() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(PASSWORD_KEY) ?? "";
  }

  void clearAll() async {
    var prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(JWT_TOKEN),
      prefs.remove(USER_NAME_KEY),
      prefs.remove(PASSWORD_KEY)
    ]);
  }
}
