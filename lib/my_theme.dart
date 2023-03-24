// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
