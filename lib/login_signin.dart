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
    //TODO:
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(child: SizedBox(height: 60), fit: FlexFit.loose, flex: 1),
            Logo(),
            Flexible(child: SizedBox(height: 100), fit: FlexFit.loose, flex: 2),
            Login(),
            Flexible(child: SizedBox(height: 70), fit: FlexFit.loose, flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? ",
                    style: Theme.of(context).primaryTextTheme.headline6),
                GestureDetector(
                  onTap: () => print("Sign Up switch"),
                  child: Text("Sign up!",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline6
                          .copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
