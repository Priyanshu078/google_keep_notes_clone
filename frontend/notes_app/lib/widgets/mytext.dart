import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  const MyText(
      {super.key,
      required this.text,
      this.maxLines,
      required this.fontSize,
      required this.fontWeight,
      required this.color,
      this.overflow});

  final String text;
  final int? maxLines;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.notoSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
