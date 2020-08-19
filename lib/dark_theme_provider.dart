import 'package:flutter/material.dart';
import 'package:rank_ten/preferences_store.dart';

class DarkThemeProvider with ChangeNotifier {
  PreferencesStore store = PreferencesStore();
  bool _isDark = false;

  bool get isDark => _isDark;

  set isDark(bool val) {
    _isDark = val;
    store.saveDarkTheme(val);
    notifyListeners();
  }
}
