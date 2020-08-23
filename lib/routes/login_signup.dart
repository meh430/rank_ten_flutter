import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/auth.dart';
import 'package:rank_ten/components/login.dart';
import 'package:rank_ten/components/logo.dart';
import 'package:rank_ten/components/signup.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

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
  MainUserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<MainUserProvider>(context, listen: false);
  }

  void _handleLogin(String uName, String pwd) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var userData =
          await Authorization.loginUser(userName: uName, password: pwd);
      print(userData);

      userProvider.jwtToken = userData.jwtToken;
      userProvider.initMainUser(userData);

      setState(() {
        _isLoading = false;
      });

      //push home route
      Navigator.pop(context);
      Navigator.pushNamed(context, '/main');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _logSignScaffKey.currentState.hideCurrentSnackBar();
      _logSignScaffKey.currentState
          .showSnackBar(Utils.getSB('Incorrect username or password'));
    }
  }

  void _handleSignup(String uName, String pwd, String bio) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var userData = await Authorization.signupUser(
          userName: uName, password: pwd, bio: bio);
      print(userData);
      userProvider.jwtToken = userData.jwtToken;
      userProvider.initMainUser(userData);
      setState(() {
        _isLoading = false;
      });

      //push home route
      Navigator.pop(context);
      Navigator.pushNamed(context, '/main');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _logSignScaffKey.currentState.hideCurrentSnackBar();
      _logSignScaffKey.currentState
          .showSnackBar(Utils.getSB('Username already exists'));
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
            Flexible(
                child: const SizedBox(height: 60), fit: FlexFit.tight, flex: 1),
            Logo(),
            Flexible(
                child: const SizedBox(height: 100),
                fit: FlexFit.tight,
                flex: 1),
            _isLogin
                ? Login(
                    submitLogin: _handleLogin,
                    isLoading: _isLoading,
                    pController: _pController,
                    uController: _uController)
                : Signup(
                    submitSignup: _handleSignup,
                    isLoading: _isLoading,
                    pController: _pController,
                    uController: _uController,
                    bController: _bController,
                    pConfirmController: _pConfirmController),
            Flexible(
                child: const SizedBox(height: 70), fit: FlexFit.tight, flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_isLogin ? "Don't have an account? " : "Have an account? ",
                    style: Theme.of(context).textTheme.headline6),
                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? "Sign up!" : "Log in!",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
