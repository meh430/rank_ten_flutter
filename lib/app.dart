import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/app_theme.dart';
import 'package:rank_ten/dark_theme_provider.dart';
import 'package:rank_ten/routes/login_signup.dart';
import 'package:rank_ten/routes/main_screen.dart';
import 'package:rank_ten/routes/splash.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var themeProvider = DarkThemeProvider();
  var mainUserBloc;

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  void getCurrentTheme() async {
    themeProvider.isDark = await themeProvider.store.isDark();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          title: "RankTen",
          theme: AppTheme.getAppTheme(themeProvider.isDark),
          darkTheme: AppTheme.getAppTheme(themeProvider.isDark),
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => Splash(),
            '/login_signup': (context) => LoginSignup(),
            '/main': (context) => MainScreen()
          },
        );
      }),
    );
  }
}
