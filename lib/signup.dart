import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dark_theme_provider.dart';
import 'login.dart';

typedef SubmitSignup = void Function(String, String, String);

String validateBio(String value) {
  if (value.isEmpty) {
    return "Please enter a bio";
  }

  return null;
}

class Signup extends StatelessWidget {
  final SubmitSignup submitSignup;
  final bool isLoading;
  final _uController = TextEditingController();
  final _pController = TextEditingController();
  final _pConfirmController = TextEditingController();
  final _bController = TextEditingController();
  final _fKey = GlobalKey<FormState>();

  Signup({this.submitSignup, this.isLoading});

  submitForm(BuildContext context) {
    if (_pController.text != _pConfirmController.text) {
      print("BRUH");
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please confirm password"),
          behavior: SnackBarBehavior.floating));
    } else if (_fKey.currentState.validate()) {
      final password = _pController.text;
      final username = _uController.text;
      final bio = _bController.text;
      print(username + ", " + password + ", " + bio);
      submitSignup(username, password, bio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle =
        Theme.of(context).primaryTextTheme.headline6.copyWith(fontSize: 16);

    final textFields = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getNameField(_uController, labelStyle, context),
          SizedBox(height: 20.0),
          PasswordField(
              pController: _pController,
              labelStyle: labelStyle,
              fieldValidator: validatePwd),
          SizedBox(height: 20.0),
          PasswordField(
            pController: _pConfirmController,
            labelStyle: labelStyle,
            fieldValidator: validatePwd,
            confirm: true,
          ),
          SizedBox(height: 20.0),
          getBioField(_bController, labelStyle, context)
        ]);

    return Form(
      key: _fKey,
      child: Column(
        children: <Widget>[
          getFormWrapper(textFields),
          SizedBox(height: 20),
          getSubmitButton(
              context: context,
              isLoading: isLoading,
              isLogin: false,
              submitData: submitForm)
        ],
      ),
    );
  }
}

TextFormField getBioField(TextEditingController bController,
    TextStyle labelStyle, BuildContext context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  print(themeChange.isDark);
  return TextFormField(
      controller: bController,
      validator: validateBio,
      maxLines: 3,
      decoration: InputDecoration(
          labelText: 'Bio',
          contentPadding: EdgeInsets.all(20.0),
          labelStyle: labelStyle,
          border: getInputStyle(themeChange.isDark),
          enabledBorder: getInputStyle(themeChange.isDark),
          focusedBorder: getInputStyle(themeChange.isDark)));
}
