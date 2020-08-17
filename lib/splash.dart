import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/app.dart';
import 'package:rank_ten/logo.dart';
import 'package:rank_ten/preferences_store.dart';

import 'app_theme.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startUpFlow();
    //Future.delayed(Duration(milliseconds: 2000),
    //    () => Navigator.pushNamed(context, '/login_signup'));
  }

  void startUpFlow() async {
    var store = PreferencesStore();
    var token = await store.getToken();
    //check if token present
    print("Checking if token present...");
    if (token != "") {
      print("Token present. Checking validity...");
      var userData = await Authorization.tokenValid(token);
      //ensure token validity
      if (userData is RankExceptions) {
        print("Token invalid...");
        checkForPwd(store);
      } else {
        print("Token valid. Parsed user data");
        print(userData);
        mainUser = userData;
        //TODO: push home route
      }
    } else {
      print("Token not present...");
      checkForPwd(store);
    }
  }

  void checkForPwd(PreferencesStore store) async {
    print("Checking if credentials present...");
    var userName = await store.getUserName();
    var password = await store.getPwd();

    //check if credentials present
    if (userName != "" && password != "") {
      print("Credentials present. Checking validity...");
      var userData =
          await Authorization.loginUser(userName: userName, password: password);
      if (userData is RankExceptions) {
        print("Credentials invalid. Starting login/signup flow");
        Navigator.pushNamed(context, '/login_signup');
      } else {
        print("Credentials valid. Parsed user data");
        print(userData);
        mainUser = userData;
        //TODO: push home route
      }
    } else {
      print("Credentials not present. Starting login/signup flow");
      Navigator.pushNamed(context, '/login_signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Logo(),
          SizedBox(height: 200, width: 50),
          SpinKitCubeGrid(
            color: hanPurple,
            size: 70.0,
          )
        ])));
  }
}
