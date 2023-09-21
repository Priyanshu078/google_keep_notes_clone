import 'package:flutter/material.dart';
import 'package:notes_app/widgets/mytext.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
          color: Colors.white,
        ),
        width: width * 0.85,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: [
              Image.asset("assets/google-keep-logo.png"),
              ListTile(
                leading: const Icon(Icons.lightbulb_outline_rounded),
                title: const MyText(
                  text: "Notes",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_outline_rounded),
                title: const MyText(
                  text: "Notes",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_outline_rounded),
                title: const MyText(
                  text: "Notes",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_outline_rounded),
                title: const MyText(
                  text: "Notes",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_outline_rounded),
                title: const MyText(
                  text: "Help & feedback",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
