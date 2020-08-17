import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/app_theme.dart';

import 'dark_theme_provider.dart';

typedef SubmitLogin = void Function(String, String);

const inputStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)));

OutlineInputBorder getInputStyle(bool isDark) {
  return OutlineInputBorder(
      borderSide:
          BorderSide(color: isDark ? palePurple : Colors.black, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)));
}

dynamic getSubmitButton(
    {BuildContext context, bool isLogin, bool isLoading, dynamic submitData}) {
  return isLoading
      ? SpinKitDoubleBounce(
          color: hanPurple,
          size: 50.0,
        )
      : RaisedButton(
          padding:
              EdgeInsets.only(left: 40.0, right: 40.0, top: 8.0, bottom: 8.0),
          color: paraPink,
          onPressed: () => submitData(context),
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

class Login extends StatelessWidget {
  final SubmitLogin submitLogin;
  final bool isLoading;
  var uController; //= TextEditingController();
  var pController; //= TextEditingController();
  final _fKey = GlobalKey<FormState>();

  Login({this.submitLogin, this.isLoading, this.uController, this.pController});

  submitForm(BuildContext context) {
    if (_fKey.currentState.validate()) {
      final password = pController.text;
      final username = uController.text;
      print(username + ", " + password);
      submitLogin(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle =
    Theme
        .of(context)
        .primaryTextTheme
        .headline6
        .copyWith(fontSize: 16);

    final textFields = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getNameField(uController, labelStyle, context),
          SizedBox(height: 20.0),
          PasswordField(
              pController: pController,
              labelStyle: labelStyle,
              fieldValidator: validatePwd)
        ]);

    return Form(
      key: _fKey,
      child: Column(
        children: <Widget>[
          getFormWrapper(textFields),
          SizedBox(height: 80),
          getSubmitButton(
              context: context,
              isLoading: isLoading,
              isLogin: true,
              submitData: submitForm)
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController pController;
  final labelStyle;
  final fieldValidator;
  final bool confirm;

  PasswordField({this.pController,
    this.labelStyle,
    this.fieldValidator,
    this.confirm = false});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return TextFormField(
        controller: widget.pController,
        validator: widget.fieldValidator,
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
            contentPadding: EdgeInsets.all(20.0),
            labelText: widget.confirm ? 'Confirm Password' : 'Password',
            border: getInputStyle(themeChange.isDark),
            labelStyle: widget.labelStyle,
            enabledBorder: getInputStyle(themeChange.isDark),
            focusedBorder: getInputStyle(themeChange.isDark)));
  }
}

TextFormField getNameField(TextEditingController uController,
    TextStyle labelStyle, BuildContext context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return TextFormField(
      controller: uController,
      validator: validateUsername,
      decoration: InputDecoration(
          labelText: 'Username',
          contentPadding: EdgeInsets.all(20.0),
          labelStyle: labelStyle,
          border: getInputStyle(themeChange.isDark),
          enabledBorder: getInputStyle(themeChange.isDark),
          focusedBorder: getInputStyle(themeChange.isDark)));
}

Card getFormWrapper(dynamic textFields) {
  return Card(
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
  );
}
