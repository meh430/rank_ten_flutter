import 'package:flutter/material.dart';
import 'package:rank_ten/routes/list_screen.dart';
import 'package:rank_ten/routes/login_signup.dart';
import 'package:rank_ten/routes/main_screen.dart';
import 'package:rank_ten/routes/splash.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (context) => Splash());
      case '/login_signup':
        return MaterialPageRoute(builder: (context) => LoginSignup());
      case '/main':
        return MaterialPageRoute(builder: (context) => MainScreen());
      case '/lists':
        final ListScreenArgs args = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => ListScreen(
                listType: args.listType, name: args.name, token: args.token));
    }
  }
}
