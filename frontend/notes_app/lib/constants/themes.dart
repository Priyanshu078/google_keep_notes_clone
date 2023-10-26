import 'package:flutter/material.dart';
import 'package:notes_app/constants/colors.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
  );
  static final darkTheme = ThemeData(
      useMaterial3: true, scaffoldBackgroundColor: darkmodeScaffoldColor);
}
