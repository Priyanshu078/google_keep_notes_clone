import 'package:flutter/material.dart';
import 'package:notes_app/blocs and cubits/notes_bloc/notes_states.dart';
import 'themes.dart' as my_theme;

Color textFieldBackgroundColor = const Color(0xfff4f7fc);
Color bottomBannerColor = const Color(0xfff2f5fc);
Color fabColor = const Color(0xffeff4fa);
Color dividerColor = const Color(0xffdae5f4);
Color rippleColor = const Color(0xffe6eef9);
Color selectedColor = const Color(0xffc3e7ff);
Color selectedTextColor = const Color(0xff124b99);
Color selectedBorderColor = const Color(0xff00658b);
Color darkModeScaffoldColor = const Color(0xff181c1f);
Color themeColorDarkMode = const Color(0xff1f282d);

const List<Color> colorsLightMode = [
  Color(0xffFFFFFF),
  Color(0xfffaafa9),
  Color(0xfff29f75),
  Color(0xfffff8b9),
  Color(0xffcfdfc2),
  Color(0xffa6c9c2),
  Color(0xffd3e4ec),
  Color(0xffa1bbc8),
  Color(0xffd3bedb),
  Color(0xfff5e2dc),
  Color(0xffe9e3d3),
  Color(0xffefeff1),
];

const List<Color> colorsDarkMode = [
  Color(0xff171b1e),
  Color(0xff76172d),
  Color(0xff692a18),
  Color(0xff7c4a03),
  Color(0xff294056),
  Color(0xff256476),
  Color(0xff0c635d),
  Color(0xff264d3b),
  Color(0xff482e5b),
  Color(0xff6d394f),
  Color(0xff4b443a),
  Color(0xff232428),
];

Color getColor(
    BuildContext context,
    NotesStates notesStates,
    int colorIndex,
    ) {
  return notesStates.theme == my_theme.Theme.lightMode
      ? colorsLightMode[colorIndex]
      : notesStates.theme == my_theme.Theme.darkMode
      ? colorsDarkMode[colorIndex]
      : Theme.of(context).brightness == Brightness.dark
      ? colorsDarkMode[colorIndex]
      : colorsLightMode[colorIndex];
}