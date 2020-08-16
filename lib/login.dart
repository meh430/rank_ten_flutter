import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          child: SizedBox(
            height: 100,
            width: 100,
          ),
        ),
        RaisedButton(
          onPressed: () {
            print("pressed");
          },
          child: Text("Login"),
        )
      ],
    );
  }
}
