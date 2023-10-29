import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  MyPainter({required this.context});

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - size.width * 0.255, 0);
    path.arcToPoint(
        Offset(size.width - size.width * 0.20, size.height / 1.7 + 1),
        radius: const Radius.circular(25),
        clockwise: false);
    path.lineTo(size.width - size.width * 0.13, size.height / 1.7 + 1);
    path.arcToPoint(Offset(size.width - size.width * 0.07, 0),
        radius: const Radius.circular(25), clockwise: false);
    // path.lineTo(size.width - 27, 0);
    path.lineTo(size.width, 0);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // path.close();

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Theme.of(context).brightness == Brightness.dark
          ? Colors.black12
          : Colors.grey.shade300;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
