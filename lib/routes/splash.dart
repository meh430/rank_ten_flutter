import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/components/logo.dart';
import 'package:rank_ten/main_user_provider.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/preferences_store.dart';

import '../app_theme.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/main');
    });
    //startUpFlow();
  }

  void startUpFlow() async {
    final MainUserProvider mainUserProvider =
        Provider.of<MainUserProvider>(context);
    var store = PreferencesStore();
    //store.clearAll();
    var token = await store.getToken();
    //check if token present
    print("Checking if token present...");
    if (token != "") {
      print("Token present. Checking validity...");
      //ensure token validity
      try {
        var userData = (await Authorization.tokenValid(token)) as User;
        print("Token valid. Parsed user data");
        print(userData);
        mainUserProvider.initMainUser(userData.userName);

        //TODO: push home route
      } catch (e) {
        print("Token invalid...");
        checkForPwd(store, mainUserProvider);
      }
    } else {
      print("Token not present...");
      checkForPwd(store, mainUserProvider);
    }
  }

  void checkForPwd(
      PreferencesStore store, MainUserProvider userProvider) async {
    print("Checking if credentials present...");
    var userName = await store.getUserName();
    var password = await store.getPwd();

    //check if credentials present
    if (userName != "" && password != "") {
      print("Credentials present. Checking validity...");

      try {
        var userData = await Authorization.loginUser(
            userName: userName, password: password);
        print("Credentials valid. Parsed user data");
        print(userData);

        userProvider.initMainUser(userData.userName);
        //TODO: push home route
      } catch (e) {
        print("Credentials invalid. Starting login/signup flow");
        Navigator.pushNamed(context, '/login_signup');
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