import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';

typedef SubmitLogin = void Function(String, String);

OutlineInputBorder getInputStyle(bool isDark) {
  return OutlineInputBorder(
      borderSide:
          BorderSide(color: isDark ? palePurple : Colors.black, width: 2.0),
      borderRadius: BorderRadius.circular(40.0));
}

class SubmitButton extends StatelessWidget {
  final submitData;
  final bool isLoading;
  final bool isLogin;

  SubmitButton(
      {@required this.submitData,
      @required this.isLoading,
      @required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitDoubleBounce(
            color: hanPurple,
            size: 50.0,
          )
        : RaisedButton(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 8.0, bottom: 8.0),
            color: paraPink,
            onPressed: () => submitData(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Text(isLogin ? "Login" : "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: palePurple)),
          );
  }
}

String validatePwd(String value) {
  final pwdPattern = RegExp(r'^[a-zA-Z0-9_#?!@$ %^&*-]{6,}$');
  if (!pwdPattern.hasMatch(value)) {
    return "Password needs at least 6 characters";
  }

  return null;
}

String validateUsername(String value) {
  final namePattern = RegExp(r'^[a-zA-Z0-9_#?!@$ %^&*-]{3,}$');
  if (!namePattern.hasMatch(value)) {
    return "Username needs at least 3 characters";
  }

  return null;
}

class Login extends StatelessWidget {
  final SubmitLogin submitLogin;
  final bool isLoading;
  final uController;
  final pController;
  final _fKey = GlobalKey<FormState>();

  Login(
      {@required this.submitLogin,
      @required this.isLoading,
      @required this.uController,
      @required this.pController});

  submitForm(BuildContext context) {
    if (_fKey.currentState.validate()) {
      final password = pController.text;
      final username = uController.text;
      submitLogin(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle =
        Theme.of(context).textTheme.headline6.copyWith(fontSize: 16);

    final textFields = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          NameField(uController: uController, labelStyle: labelStyle),
          const SizedBox(height: 20.0),
          PasswordField(
              pController: pController,
              labelStyle: labelStyle,
              fieldValidator: validatePwd)
        ]);

    return Form(
      key: _fKey,
      child: Column(
        children: <Widget>[
          FormWrapper(textFields: textFields),
          const SizedBox(height: 80),
          SubmitButton(
              isLoading: isLoading, isLogin: true, submitData: submitForm)
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

  PasswordField(
      {@required this.pController,
      @required this.labelStyle,
      @required this.fieldValidator,
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
        style: TextStyle(color: themeChange.isDark ? white : Colors.black),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(obscureText ? Icons.visibility : Icons.visibility_off,
                  color: themeChange.isDark ? palePurple : Colors.black,
                  semanticLabel:
                      obscureText ? 'Show password' : 'Hide password'),
            ),
            contentPadding: const EdgeInsets.all(20.0),
            labelText: widget.confirm ? 'Confirm Password' : 'Password',
            border: getInputStyle(themeChange.isDark),
            labelStyle: widget.labelStyle,
            enabledBorder: getInputStyle(themeChange.isDark),
            focusedBorder: getInputStyle(themeChange.isDark)));
  }
}

class NameField extends StatelessWidget {
  final uController;
  final labelStyle;

  NameField({@required this.uController, @required this.labelStyle});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<DarkThemeProvider>(context).isDark;
    return TextFormField(
        controller: uController,
        style: TextStyle(color: isDark ? white : Colors.black),
        validator: validateUsername,
        decoration: InputDecoration(
            labelText: 'Username',
            contentPadding: const EdgeInsets.all(20.0),
            labelStyle: labelStyle,
            border: getInputStyle(isDark),
            enabledBorder: getInputStyle(isDark),
            focusedBorder: getInputStyle(isDark)));
  }
}

class FormWrapper extends StatelessWidget {
  final textFields;

  FormWrapper({@required this.textFields});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: textFields,
        ),
      ),
    );
  }
}
