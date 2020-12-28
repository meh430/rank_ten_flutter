import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStore {
  static const DARK_THEME = "DARKTHEME";
  static const JWT_TOKEN = "JWTTOKEN";
  static const USER_NAME_KEY = "USERNAME";
  static const PASSWORD_KEY = "PASSWORD";
  static const SAVED_SORT = "SAVEDSORT";
  static int currentSort = 0;

  static void saveDarkTheme(bool val) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(DARK_THEME, val);
  }

  static void saveCred(String token, String un, String pwd) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(JWT_TOKEN, token);
    prefs.setString(USER_NAME_KEY, un);
    prefs.setString(PASSWORD_KEY, pwd);
  }

  static void saveSort(int sort) async {
    currentSort = sort;
    (await SharedPreferences.getInstance()).setInt(SAVED_SORT, sort);
  }

  static Future<int> getSavedSort() async {
    return (await SharedPreferences.getInstance()).getInt(SAVED_SORT) ?? 0;
  }

  static Future<bool> isDark() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(DARK_THEME) ?? false;
  }

  static Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(JWT_TOKEN) ?? "";
  }

  static Future<String> getUserName() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_NAME_KEY) ?? "";
  }

  static Future<String> getPwd() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(PASSWORD_KEY) ?? "";
  }

  static void clearAll() async {
    var prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(JWT_TOKEN),
      prefs.remove(USER_NAME_KEY),
      prefs.remove(PASSWORD_KEY)
    ]);
  }
}
