import 'package:flutter/material.dart';
import 'package:notes_app/constants/colors.dart';
import 'package:notes_app/widgets/mytext.dart';

class Utilities {
  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: MyText(
        text: text,
        textStyle: Theme.of(context).textTheme.headlineMedium,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? themeColorDarkMode
          : bottomBannerColor,
      behavior: SnackBarBehavior.fixed,
    ));
  }
}
