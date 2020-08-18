import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/app_theme.dart';
import 'package:rank_ten/dark_theme_provider.dart';
import 'package:rank_ten/login_signup.dart';
import 'package:rank_ten/main_screen.dart';
import 'package:rank_ten/splash.dart';

import 'models/user.dart';

User mainUser;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _themeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    _getCurrentTheme();
  }

  _getCurrentTheme() async {
    _themeProvider.isDark = await _themeProvider.store.isDark();
    _themeProvider.isDark = true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _themeProvider,
      child: MaterialApp(
        title: "RankTen",
        theme: AppTheme.getAppTheme(false),
        darkTheme: AppTheme.getAppTheme(true),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => Splash(),
          '/login_signup': (context) => LoginSignup(),
          '/main': (context) => MainScreen()
        },
      ),
    );
  }
}
