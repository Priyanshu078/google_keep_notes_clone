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
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: textColor ?? Theme.of(context).colorScheme.primary,
        ));
  }
}
