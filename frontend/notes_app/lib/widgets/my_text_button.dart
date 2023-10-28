import 'package:flutter/material.dart';

import 'mytext.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton(
      {super.key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      required this.onPressed});

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: MyText(
          text: text,
          textStyle: Theme.of(context).textTheme.headlineMedium,
        ));
  }
}
