import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/login.dart';
import 'package:rank_ten/logo.dart';
import 'package:rank_ten/preferences_store.dart';
import 'package:rank_ten/signup.dart';

import 'api/rank_exceptions.dart';

class LoginSignup extends StatefulWidget {
  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final GlobalKey<ScaffoldState> _logSignScaffKey = GlobalKey<ScaffoldState>();
  var _pController = TextEditingController();
  var _pConfirmController = TextEditingController();
  var _uController = TextEditingController();
  var _bController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  var _prefStore = PreferencesStore();

  void _handleLogin(String uName, String pwd) async {
    setState(() {
      _isLoading = true;
    });
    var userData =
        await Authorization.loginUser(userName: uName, password: pwd);

    if (userData is RankExceptions) {
      setState(() {
        _isLoading = false;
      });
      _logSignScaffKey.currentState.hideCurrentSnackBar();
      _logSignScaffKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Incorrect username or password'),
      ));
    } else {
      await _prefStore.saveCred(userData['jwt_token'], uName, pwd);
      print(userData);
      setState(() {
        _isLoading = false;
      });
      //TODO: push home route
    }
  }

  void _handleSignup(String uName, String pwd, String bio) async {
    setState(() {
      _isLoading = true;
    });
    var userData = await Authorization.signupUser(
        userName: uName, password: pwd, bio: bio);

    if (userData is RankExceptions) {
      setState(() {
        _isLoading = false;
      });
      _logSignScaffKey.currentState.hideCurrentSnackBar();
      _logSignScaffKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Username already exists'),
      ));
    } else {
      await _prefStore.saveCred(userData['jwt_token'], uName, pwd);
      print(userData);
      setState(() {
        _isLoading = false;
      });
      //TODO: push home route
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
            _isLogin
                ? Login(
                submitLogin: _handleLogin,
                isLoading: _isLoading,
                pController: _pController,
                uController: _uController
            )
                : Signup(
                submitSignup: _handleSignup,
                isLoading: _isLoading,
                pController: _pController,
                uController: _uController,
                bController: _bController,
                pConfirmController: _pConfirmController
            ),
            Flexible(child: SizedBox(height: 70), fit: FlexFit.tight, flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_isLogin ? "Don't have an account? " : "Have an account? ",
                    style: Theme
                        .of(context)
                        .primaryTextTheme
                        .headline6),
                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? "Sign up!" : "Log in!",
                      style: Theme
                          .of(context)
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
