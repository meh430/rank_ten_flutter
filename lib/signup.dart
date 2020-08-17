import 'dart:core';

typedef SubmitSignup = void Function(String, String, String);

String validateBio(String value) {
  if (value.isEmpty) {
    return "Please enter a bio";
  }

  return null;
}
