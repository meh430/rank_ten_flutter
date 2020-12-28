import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_theme.dart';

const LIKES_DESC = 0;
const DATE_DESC = 1;
const DATE_ASC = 2;

var colors = [
  Colors.red,
  Colors.green,
  Colors.amber,
  Colors.amberAccent,
  Colors.purple,
  paraPink,
  Colors.teal,
  Colors.deepOrange,
  Colors.blue,
  Colors.cyanAccent,
  Colors.tealAccent,
  Colors.pinkAccent,
  Colors.indigo
];

class Utils {
  static String getTimeDiff(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds >= 0 && diff.inSeconds < 60) {
      time = 'Just Now';
    } else if (diff.inMinutes >= 1 && diff.inMinutes < 60) {
      time = diff.inMinutes.toString() + 'm ago';
    } else if (diff.inHours >= 1 && diff.inHours < 24) {
      time = diff.inHours.toString() + 'h ago';
    } else if (diff.inDays >= 1 && diff.inDays < 30) {
      if (diff.inDays >= 1 && diff.inDays < 7) {
        time = diff.inDays.toString() + 'd ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + 'w ago';
      }
    } else if (diff.inDays >= 30 && diff.inDays < 365) {
      time = (diff.inDays / 30).floor().toString() + 'mo ago';
    } else {
      time = (diff.inDays / 365).floor().toString() + 'y ago';
    }

    return time;
  }

  static String getDate(int timestamp) {
    return DateFormat('MMM dd, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  static SnackBar getSB(String text) {
    return SnackBar(content: Text(text), behavior: SnackBarBehavior.floating);
  }

  static Color getRandomColor() {
    return colors[Random().nextInt(colors.length)];
  }

  static void showSB(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(getSB(text));
  }

  static Row getErrorImage() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset("assets/error_triangle.png", scale: 2)]);
  }
}
