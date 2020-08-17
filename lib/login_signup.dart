import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/login.dart';
import 'package:rank_ten/logo.dart';
import 'package:rank_ten/preferences_store.dart';

class LoginSignup extends StatefulWidget {
  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final GlobalKey<ScaffoldState> _logSignScaffKey = GlobalKey<ScaffoldState>();

  bool isLogin = true;
  var prefStore = PreferencesStore();

  void handleLogin(String uName, String pwd) async {
    var userData =
        await Authorization.loginUser(userName: uName, password: pwd);
    if (userData is Map<String, dynamic>) {
      await prefStore.saveCred(userData['jwt_token'], uName, pwd);
      print(userData);
      //TODO: push new route
    } else {
      _logSignScaffKey.currentState.hideCurrentSnackBar();
      _logSignScaffKey.currentState.showSnackBar(SnackBar(
        content: Text('Incorrect username or password'),
      ));
    }
  }

  void handleSignup(String uName, String pwd, String bio) async {
    var userData = await Authorization.signupUser(
        userName: uName, password: pwd, bio: bio);

    if (userData.containsKey('jwt_token')) {
      await prefStore.saveCred(userData['jwt_token'], uName, pwd);
      print(userData);
      //TODO: push new route
    } else {
      _logSignScaffKey.currentState.hideCurrentSnackBar();
      _logSignScaffKey.currentState.showSnackBar(SnackBar(
        content: Text('Incorrect username or password'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _logSignScaffKey,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: SizedBox(height: 60), fit: FlexFit.tight, flex: 1),
            Logo(),
            Flexible(child: SizedBox(height: 100), fit: FlexFit.tight, flex: 1),
            Login(handleLogin: handleLogin),
            Flexible(child: SizedBox(height: 70), fit: FlexFit.tight, flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? ",
                    style: Theme.of(context).primaryTextTheme.headline6),
                GestureDetector(
                  onTap: () => setState(() => isLogin = !isLogin),
                  child: Text("Sign up!",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline6
                          .copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                )
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
