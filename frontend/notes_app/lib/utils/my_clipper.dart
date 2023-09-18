import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  const MyClipper({required this.height, required this.width});

  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.moveTo(0, size.height);
    // path.lineTo(size.width, height - 2 * size.height);
    // path.lineTo(size.height, height - 2 * size.height);
    // path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
