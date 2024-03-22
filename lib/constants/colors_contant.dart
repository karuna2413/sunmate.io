import 'package:flutter/material.dart';

class LightColors {
  static const appLogo = "light-logo.png";
  static const Color GreyTextColor = Color(0xFF6b6b6b);
  static const Color textColorGrey = Color(0xFF6b6b6b);

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF2B2B2B);
  static const Color borderColor = Color(0xFFE1E1E1);
  static const Color cardborderColor = Color(0xFFE1E1E1);
  static const Color buttonColor = Color(0xFF4565E7);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color inputColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB3261E);
  static const Color gridLoad = Color(0xFFFD7448);
  static const Color battaryLoad = Color(0xFF4565e7);
  static const Color houseLoad = Color(0xFFFFB800);
  static const Color production = Color(0xFF1AB58D);
  static const Color textColorblack = Color(0xFF000000);
  static const Color textColorwhite = Color(0xFFFFFFFF);
  static const Color dropdownColor = Color(0xFFFFFFFF);
  static const Color iconColor = Color(0xFFFFFFFF);
  // Map color names to color values
  static Map<String, Color> colors = {
    'GreyTextColor': GreyTextColor,
    'backgroundColor': backgroundColor,
    'textColorGrey': textColorGrey,
    'borderColor': borderColor,
    'buttonColor': buttonColor,
    'cardborderColor': cardborderColor,
    'textColor': textColor,
    'buttonTextColor': buttonTextColor,
    'inputColor': inputColor,
    'errorColor': errorColor,
    'gridLoad': gridLoad,
    'battaryLoad': battaryLoad,
    'houseLoad': houseLoad,
    'production': production,
    'textColorblack': textColorblack,
    'textColorwhite': textColorwhite,
    'iconColor': iconColor,
    'dropdownColor': dropdownColor,
  };
}

class DarkColors {
  static const appLogo = "dark-logo.png";
  static const Color GreyTextColor = Color(0xFF6b6b6b);
  static const Color textColorGrey = Color(0xFFFFFFFF);

  static const Color backgroundColor = Color(0xFF000000);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFF232020);
  static const Color cardborderColor = Color(0xFFFFFFFF);
  static const Color buttonColor = Color(0xFFdcedc2);
  static const Color buttonTextColor = Color(0xFF171717);
  static const Color inputColor = Color(0xFF232020);
  static const Color errorColor = Color(0xFFB3261E);
  static const Color gridLoad = Color(0xFFFD7448);
  static const Color battaryLoad = Color(0xFFDCEDC2);
  static const Color houseLoad = Color(0xFFFFB800);
  static const Color production = Color(0xFF1AB58D);
  static const Color textColorblack = Color(0xFF000000);
  static const Color textColorwhite = Color(0xFFFFFFFF);
  static const Color dropdownColor = Color(0xFFdcedc2);
  static const Color iconColor = Color(0xFF000000);

  // Map color names to color values
  static Map<String, Color> colors = {
    'GreyTextColor': GreyTextColor,
    'textColorGrey': textColorGrey,
    'backgroundColor': backgroundColor,
    'borderColor': borderColor,
    'cardborderColor': cardborderColor,
    'buttonColor': buttonColor,
    'textColor': textColor,
    'buttonTextColor': buttonTextColor,
    'inputColor': inputColor,
    'errorColor': errorColor,
    'gridLoad': gridLoad,
    'battaryLoad': battaryLoad,
    'houseLoad': houseLoad,
    'production': production,
    'textColorblack': textColorblack,
    'textColorwhite': textColorwhite,
    'iconColor': iconColor,
    'dropdownColor': dropdownColor,
  };
}

Color getColors(bool mode, String color) {
  return (mode ? DarkColors.colors[color] : LightColors.colors[color]) ??
      Colors.transparent;
}

String getLogo(bool mode) {
  return mode ? "dark-logo.png" : "light-logo.png";
}

String getHome(bool mode) {
  return mode ? "home1.png" : "home2.png";
}
