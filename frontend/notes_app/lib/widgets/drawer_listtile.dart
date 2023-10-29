import 'package:flutter/material.dart';
import 'package:notes_app/widgets/mytext.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.isTheme,
    required this.themeText,
    required this.height,
    required this.width,
  });

  final IconData icon;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double height;
  final double width;
  final bool isTheme;
  final String themeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
            ),
            SizedBox(
              width: width * 0.04,
            ),
            MyText(
              text: text,
              textStyle: Theme.of(context).textTheme.headlineSmall,
            ),
            isTheme
                ? Expanded(
                    child: Container(),
                  )
                : Container(),
            isTheme
                ? MyText(
                    text: themeText,
                    textStyle: Theme.of(context).textTheme.displayMedium,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
