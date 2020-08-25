import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';

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
  final uController;
  final pController;
  final pConfirmController;
  final bController;
  final _fKey = GlobalKey<FormState>();

  Signup(
      {@required this.submitSignup,
      @required this.isLoading,
      @required this.pController,
      @required this.uController,
      @required this.pConfirmController,
      @required this.bController});

  submitForm(BuildContext context) {
    if (pController.text != pConfirmController.text) {
      Scaffold.of(context).showSnackBar(Utils.getSB('Please confirm password'));
    } else if (_fKey.currentState.validate()) {
      final password = pController.text;
      final username = uController.text;
      final bio = bController.text;
      submitSignup(username, password, bio);
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
              fieldValidator: validatePwd),
          const SizedBox(height: 20.0),
          PasswordField(
            pController: pConfirmController,
            labelStyle: labelStyle,
            fieldValidator: validatePwd,
            confirm: true,
          ),
          const SizedBox(height: 20.0),
          getBioField(bController, labelStyle, context)
        ]);

    return Form(
      key: _fKey,
      child: Column(
        children: <Widget>[
          FormWrapper(textFields: textFields),
          const SizedBox(height: 20),
          SubmitButton(
              isLoading: isLoading, isLogin: false, submitData: submitForm)
        ],
      ),
    );
  }
}

TextFormField getBioField(TextEditingController bController,
    TextStyle labelStyle, BuildContext context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return TextFormField(
      controller: bController,
      validator: validateBio,
      style: TextStyle(color: themeChange.isDark ? Colors.white : Colors.black),
      maxLines: 3,
      decoration: InputDecoration(
          labelText: 'Bio',
          contentPadding: const EdgeInsets.all(20.0),
          labelStyle: labelStyle,
          border: getInputStyle(themeChange.isDark),
          enabledBorder: getInputStyle(themeChange.isDark),
          focusedBorder: getInputStyle(themeChange.isDark)));
}
