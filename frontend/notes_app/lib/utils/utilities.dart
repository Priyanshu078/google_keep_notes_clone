import 'package:flutter/material.dart';
import 'package:notes_app/widgets/mytext.dart';

class Utilities {
  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: MyText(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
    ));
  }
}