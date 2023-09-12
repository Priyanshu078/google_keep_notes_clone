import 'package:flutter/material.dart';

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  final _shimmerGradient = const LinearGradient(
      colors: [
        Color(0xFFEBEBF4),
        Color(0xFFF4F4F4),
        Color(0xFFEBEBF4),
      ],
      stops: [
        0.1,
        0.3,
        0.4
      ],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1, 0.3),
      tileMode: TileMode.clamp);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) {
          return _shimmerGradient.createShader(bounds);
        },
        child: GridView.builder(
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: widget.height * 0.01,
                            ),
                            Container(
                              height: widget.height * 0.035,
                              width: widget.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: widget.height * 0.04,
                            ),
                            Container(
                              height: widget.height * 0.025,
                              width: widget.width * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: widget.height * 0.02,
                            ),
                            Container(
                              height: widget.height * 0.025,
                              width: widget.width * 0.25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: widget.height * 0.02,
                            ),
                            Container(
                              height: widget.height * 0.025,
                              width: widget.width * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                )),
      ),
    );
  }
}
