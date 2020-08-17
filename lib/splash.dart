import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/api/rank_exceptions.dart';
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
    // TODO: implement initState
    super.initState();
    startUpFlow();
    Future.delayed(Duration(milliseconds: 2000),
        () => Navigator.pushNamed(context, '/login_signup'));
  }

  void startUpFlow() async {
    var store = PreferencesStore();
    var token = await store.getToken();
    if (token != "") {
      var userData = await Authorization.tokenValid(token);
      if (userData is RankExceptions) {
        checkForPwd(store);
      } else {
        print(userData);
        //TODO: push home route
      }
    } else {
      checkForPwd(store);
    }
  }

  void checkForPwd(PreferencesStore store) async {
    var userName = await store.getUserName();
    var password = await store.getPwd();
    if (userName != "" && password != "") {
      var userData =
          await Authorization.loginUser(userName: userName, password: password);
      if (userData is RankExceptions) {
        Navigator.pushNamed(context, '/login_signup');
      } else {
        print(userData);
        //TODO: store token
        //TODO: push home route
      }
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
