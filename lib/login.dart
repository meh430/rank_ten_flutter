import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rank_ten/app_theme.dart';

const inputStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)));

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Card(
            color: palePurple,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.only(left: 40, right: 40, bottom: 10.0),
            child: Padding(padding: EdgeInsets.all(10.0), child: LoginForm())),
        SizedBox(height: 80),
        RaisedButton(
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0, bottom: 5.0),
          color: palePurple,
          onPressed: () {
            print("pressed");
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Text("Login",
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline3
                  .copyWith(color: paraPink)),
        )
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _fKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context)
        .primaryTextTheme
        .headline6
        .copyWith(fontSize: 16)
        .copyWith(color: Colors.black);
    return Form(
      key: _fKey,
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
                decoration: InputDecoration(
                    labelText: 'Username',
                    contentPadding: EdgeInsets.all(20.0),
                    labelStyle: labelStyle,
                    border: inputStyle,
                    enabledBorder: inputStyle,
                    focusedBorder: inputStyle)),
            SizedBox(height: 20.0),
            TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    labelText: 'Password',
                    border: inputStyle,
                    labelStyle: labelStyle,
                    enabledBorder: inputStyle,
                    focusedBorder: inputStyle))
          ],
        ),
      ),
    );
  }
}
