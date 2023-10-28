import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
      {super.key,
      required this.text,
      this.maxLines,
      required this.textStyle,
      this.overflow});

  final String text;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle,
    );
  }
}
