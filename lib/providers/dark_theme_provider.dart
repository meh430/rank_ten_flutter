import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/misc/app_theme.dart';

class DarkThemeProvider with ChangeNotifier {
  PreferencesStore store = PreferencesStore();
  bool _isDark = false;

  bool get isDark => _isDark;

  set isDark(bool val) {
    _isDark = val;
    store.saveDarkTheme(val);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: _isDark ? darkBackground : Colors.white));
    notifyListeners();
  }
}
