import 'package:flutter/material.dart';
import 'package:notes_app/constants/colors.dart';

enum Theme { darkMode, lightMode, systemDefault }

class MyThemes {
  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
      useMaterial3: true,
      );
  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: darkModeScaffoldColor,
      colorScheme: ColorScheme.fromSeed(seedColor: themeColorDarkMode, brightness: Brightness.dark)
  );
}
