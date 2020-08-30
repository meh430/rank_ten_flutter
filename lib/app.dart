import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/router.dart';

import 'misc/app_theme.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var themeProvider = DarkThemeProvider();
  var mainUserProvider = MainUserProvider();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => mainUserProvider)
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          title: "RankTen",
          theme: AppTheme.getAppTheme(themeProvider.isDark),
          darkTheme: AppTheme.getAppTheme(themeProvider.isDark),
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      }),
    );
  }
}
