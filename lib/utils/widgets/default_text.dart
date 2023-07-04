import 'package:flutter/material.dart';

class DefaultText extends StatelessWidget {
  const DefaultText(
      {super.key,
      required this.text,
      required this.color,
      this.textAlign,
      this.overflow});
  final String text;
  final Color color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    double fontSize = 16;
    if (MediaQuery.of(context).size.shortestSide >= 600) {
      fontSize += 2;
    }
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.normal,
          fontSize: fontSize,
          overflow: overflow ?? TextOverflow.ellipsis),
    );
  }
}
