import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  const MyClipper({required this.height, required this.width});

  final double height;
  final double width;
  @override
  getClip(Size size) {
    Path path = Path();
    // path.moveTo(size.width - 100, 0);
    // path.lineTo(size.width - 100, size.height);
    // path.lineTo(size.width - 150, size.height);
    // path.lineTo(size.width - 150, 0);
    // path.close();
    path.moveTo(0, 0);
    path.lineTo(size.width - 93, 0);
    path.arcToPoint(Offset(size.width - 75, size.height / 2 + 1),
        radius: const Radius.circular(18), clockwise: false);
    path.lineTo(size.width - 45, size.height / 2 + 1);
    path.arcToPoint(Offset(size.width - 27, 0),
        radius: const Radius.circular(18), clockwise: false);
    // path.lineTo(size.width - 27, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
