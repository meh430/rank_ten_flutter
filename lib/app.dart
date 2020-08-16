import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/app_theme.dart';
import 'package:rank_ten/dark_theme_provider.dart';
import 'package:rank_ten/login_signin.dart';
import 'package:rank_ten/splash.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var themeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  getCurrentTheme() async {
    themeProvider.isDark = await themeProvider.store.isDark();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: MaterialApp(
        title: "RankTen",
        theme: AppTheme.getAppTheme(false),
        darkTheme: AppTheme.getAppTheme(false),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => Splash(),
          '/login_signin': (context) => LoginSignin()
        },
      ),
    );
  }
}
