import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const white = Colors.white;
const darkBackground = Color(0xff121212);
const palePurple = Color(0xffF1E3F3);
const lavender = Color(0xffC2BBF0);
const darkSienna = Color(0xff4A051C);
const hanPurple = Color(0xff6320EE);
const paraPink = Color(0xffEF476F);
const secondText = Color(0xff666666);
const lightCard = Color(0xffF2F2F2);
const darkCard = Color(0xff222222);

class AppTheme {
  static getTextColor(bool isDark) {
    return isDark ? palePurple : darkSienna;
  }

  static getTextTheme(bool isDark, TextTheme base) {
    return base.copyWith(
      headline1: GoogleFonts.nunito(color: getTextColor(isDark)),
      headline2: GoogleFonts.nunito(color: getTextColor(isDark)),
      headline3: GoogleFonts.nunito(color: getTextColor(isDark)),
      headline4: GoogleFonts.nunito(color: getTextColor(isDark)),
      headline5: GoogleFonts.nunito(color: getTextColor(isDark)),
      headline6: GoogleFonts.nunito(color: getTextColor(isDark)),
      caption: GoogleFonts.nunito(color: getTextColor(isDark)),
      bodyText1: GoogleFonts.nunito(color: getTextColor(isDark)),
    );
  }

  static getAppTheme(bool isDark) {
    var base = isDark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
        textTheme: getTextTheme(isDark, base.textTheme),
        primaryTextTheme: getTextTheme(isDark, base.primaryTextTheme),
        accentTextTheme: getTextTheme(isDark, base.accentTextTheme),
        accentColor: lavender,
        primaryColor: lavender,
        scaffoldBackgroundColor: isDark ? darkBackground : white,
        canvasColor: isDark ? darkBackground : white,
        backgroundColor: isDark ? darkBackground : white,
        cardColor: isDark ? darkCard : lightCard);
  }
}
