import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  const SmallText(
      {super.key,
      required this.text,
      required this.color,
      this.textAlign,
      this.fontStyle,
      this.decoration});
  final String text;
  final TextDecoration? decoration;
  final Color color;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  @override
  Widget build(BuildContext context) {
    double fontSize = 14;
    if (MediaQuery.of(context).size.shortestSide >= 600) {
      fontSize += 2;
    }
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        decoration: decoration ?? TextDecoration.none,
        fontStyle: fontStyle ?? FontStyle.normal,
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
      ),
    );
  }
}
