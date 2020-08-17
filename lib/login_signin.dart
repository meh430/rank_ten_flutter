import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_ten/login.dart';
import 'package:rank_ten/logo.dart';

class LoginSignin extends StatefulWidget {
  @override
  _LoginSigninState createState() => _LoginSigninState();
}

class _LoginSigninState extends State<LoginSignin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Logo(),
            Login(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? ",
                    style: Theme.of(context).primaryTextTheme.headline6),
                Text("Sign up!",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline6
                        .copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }
}
