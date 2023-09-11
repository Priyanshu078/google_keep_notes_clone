import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.035,
                            width: width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Container(
                            height: height * 0.025,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.025,
                            width: width * 0.25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.025,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              )),
    );
  }
}
