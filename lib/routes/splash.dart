import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/components/logo.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

import '../misc/app_theme.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    startUpFlow();
  }

  void startUpFlow() async {
    final MainUserProvider mainUserProvider =
        Provider.of<MainUserProvider>(context, listen: false);
    //PreferencesStore.clearAll();
    var token = await PreferencesStore.getToken();
    //check if token present
    print("Checking if token present...");
    if (token != "") {
      print("Token present. Checking validity...");
      //ensure token validity
      try {
        User userData = (await Authorization.tokenValid(token)) as User;
        mainUserProvider.jwtToken = token;
        mainUserProvider.initMainUser(userData);
        print("Token valid. Parsed user data");
        Navigator.pop(context);
        Navigator.pushNamed(context, '/main');
      } catch (e) {
        print(e);
        print("Token invalid...");
        checkForPwd(mainUserProvider);
      }
    } else {
      print("Token not present...");
      checkForPwd(mainUserProvider);
    }
  }

  void checkForPwd(MainUserProvider userProvider) async {
    print("Checking if credentials present...");
    var userName = await PreferencesStore.getUserName();
    var password = await PreferencesStore.getPwd();

    //check if credentials present
    if (userName != "" && password != "") {
      print("Credentials present. Checking validity...");

      try {
        var userData = await Authorization.loginUser(
            userName: userName, password: password);
        print(userData);
        userProvider.jwtToken = userData.jwtToken;
        userProvider.initMainUser(userData);
        print("Credentials valid. Parsed user data");

        Navigator.pop(context);
        Navigator.pushNamed(context, '/main');
      } catch (e) {
        print("Credentials invalid. Starting login/signup flow");
        Navigator.pop(context);
        Navigator.pushNamed(context, '/login_signup');
      }
    } else {
      print("Credentials not present. Starting login/signup flow");
      Navigator.pop(context);
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
          const SizedBox(height: 200, width: 50),
          const SpinKitCubeGrid(
            color: hanPurple,
            size: 70.0,
          )
        ])));
  }
}
