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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Logo(),
            Login(),
            Text("Don't have an account? Sign up!")
          ],
        ),
      ),
    );
  }
}
