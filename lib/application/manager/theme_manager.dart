import 'package:flutter/material.dart';

const Color bluishColor = Color(0xFF4e5ae8);
const Color orangeColor = Color(0xCFFF8746);
const Color pinkColor = Color(0xFFff4667);
const primaryColor = bluishColor;
const Color darkGreyColor = Color.fromARGB(255, 51, 50, 50);
const Color darkHeaderColor = Color(0xFF424242);

enum AppTheme { light, dart }

Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.light: ThemeData(
    primaryColor: primaryColor,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      accentColor: orangeColor,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(darkGreyColor),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: orangeColor),
  ),
  AppTheme.dart: ThemeData(
    primaryColor: darkGreyColor,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      color: darkGreyColor,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primaryColorDark: darkGreyColor,
      backgroundColor: darkGreyColor,
      brightness: Brightness.dark,
      accentColor: orangeColor,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(darkGreyColor),
      trackColor: MaterialStateProperty.all(Colors.white),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: orangeColor),
  ),
};
