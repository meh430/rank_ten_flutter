import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rank_ten/app_theme.dart';

const inputStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)));

typedef SubmitLogin = void Function(String, String);

RaisedButton getSubmitButton(
    BuildContext context, bool isLogin, VoidCallback submitData) {
  return RaisedButton(
    padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 8.0, bottom: 8.0),
    color: paraPink,
    onPressed: () {
      submitData();
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
    ),
    child: Text(isLogin ? "Login" : "Sign Up",
        style: Theme.of(context)
            .primaryTextTheme
            .headline3
            .copyWith(color: palePurple)),
  );
}

String validatePwd(String value) {
  final pwdPattern = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$');
  if (!pwdPattern.hasMatch(value)) {
    return "Invalid password";
  }

  return null;
}

String validateUsername(String value) {
  final namePattern = RegExp(r'^[a-z0-9_-]{3,15}$');
  if (!namePattern.hasMatch(value)) {
    return "Invalid username";
  }

  return null;
}

class Login extends StatefulWidget {
  SubmitLogin handleLogin;

  Login({this.handleLogin});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginForm(
        handleLogin: widget.handleLogin,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final SubmitLogin handleLogin;

  LoginForm({this.handleLogin});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _uController = TextEditingController();
  final _pController = TextEditingController();
  final _fKey = GlobalKey<FormState>();

  submitForm() {
    if (_fKey.currentState.validate()) {
      final password = _pController.text;
      final username = _uController.text;
      print(username + password);
      widget.handleLogin(username.toString(), password.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme
        .of(context)
        .primaryTextTheme
        .headline6
        .copyWith(fontSize: 16)
        .copyWith(color: Colors.black);

    final textFields = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getNameField(_uController, labelStyle),
          SizedBox(height: 20.0),
          PasswordField(pController: _pController, labelStyle: labelStyle)
        ]);

    return Form(
      key: _fKey,
      child: Column(
        children: <Widget>[
          Card(
            color: white,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.only(left: 40, right: 40, bottom: 10.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: textFields,
              ),
            ),
          ),
          SizedBox(height: 80),
          getSubmitButton(context, true, submitForm)
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController pController;
  final labelStyle;

  PasswordField({this.pController, this.labelStyle});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.pController,
        validator: validatePwd,
        obscureText: obscureText,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                  obscureText ? 'Show password' : 'Hide password'),
            ),
            filled: true,
            fillColor: white,
            contentPadding: EdgeInsets.all(20.0),
            labelText: 'Password',
            border: inputStyle,
            labelStyle: widget.labelStyle,
            enabledBorder: inputStyle,
            focusedBorder: inputStyle));
  }
}

TextFormField getNameField(TextEditingController uController,
    TextStyle labelStyle) {
  return TextFormField(
      maxLength: 15,
      controller: uController,
      validator: validateUsername,
      decoration: InputDecoration(
          labelText: 'Username',
          filled: true,
          fillColor: white,
          contentPadding: EdgeInsets.all(20.0),
          labelStyle: labelStyle,
          border: inputStyle,
          enabledBorder: inputStyle,
          focusedBorder: inputStyle));
}
