// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// The MyThemeData class defines two ThemeData objects, lightTheme and darkTheme,
// for a light and a dark theme respectively.The colorScheme property of the
// ThemeData objects defines the color scheme for the UI, including the primary
// and secondary colors, background, and error colors. The scaffoldBackgroundColor
// property defines the background color for the scaffold widget, which is
// the top-level widget of each screen in the app. The appBarTheme property defines
// the appearance of the app bar at the top of each screen.The textTheme property
// defines the text styles used throughout the UI for various text elements such as
// headlines and subtitles. The headline1 and headline2 text styles are used for
// larger text elements such as screen titles, while subtitle1 and subtitle2 are
// used for smaller text elements such as captions or labels.
class MyThemeData {
  static Color lightPrimary = Colors.blue[800]!;
  static Color lightSecondary = Colors.yellow[900]!;
  static Color colorBlack = Color(0xff242424);
  static Color colorWhite = Color(0xFFFFFFFF);
  static Color colorGrey = Colors.grey;
  static Color darkBlue = Color(0xff2e386b);
  static Color colorLightGreen = Color(0xffDFECDB);
  static final ThemeData lightTheme = ThemeData(
    primaryColor: lightPrimary,
    colorScheme: ColorScheme(
      primary: lightPrimary,
      onPrimary: colorLightGreen,
      secondary: lightSecondary,
      onSecondary: colorGrey,
      background: colorWhite,
      error: Colors.red,
      onError: Colors.red,
      onSurface: colorGrey,
      surface: colorBlack,
      onBackground: lightPrimary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: colorWhite,
    appBarTheme: AppBarTheme(
      color: lightSecondary,
      elevation: 4,
      iconTheme: IconThemeData(color: colorWhite),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: darkBlue,
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorWhite,
      ),
      subtitle1: TextStyle(
        fontSize: 18,
        color: colorGrey,
        fontWeight: FontWeight.w400,
      ),
      subtitle2: TextStyle(
        fontSize: 18,
        color: colorBlack,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    primaryColor: lightPrimary,
    colorScheme: ColorScheme(
      primary: lightPrimary,
      onPrimary: Color.fromARGB(255, 53, 53, 53),
      secondary: lightSecondary,
      onSecondary: colorGrey,
      background: colorBlack,
      error: Colors.red,
      onError: Colors.red,
      onSurface: colorGrey,
      surface: colorWhite,
      onBackground: colorBlack,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: colorBlack,
    appBarTheme: AppBarTheme(
      color: colorBlack,
      elevation: 4,
      iconTheme: IconThemeData(color: colorWhite),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: colorWhite,
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorWhite,
      ),
      subtitle1: TextStyle(
        fontSize: 18,
        color: colorWhite,
        fontWeight: FontWeight.w400,
      ),
      subtitle2: TextStyle(
        fontSize: 18,
        color: colorWhite,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
