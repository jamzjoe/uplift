import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  const SmallText(
      {super.key,
      required this.text,
      required this.color,
      this.textAlign,
      this.fontStyle,
      this.decoration,
      this.fontSize});
  final String text;
  final double? fontSize;
  final TextDecoration? decoration;
  final Color color;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        decoration: decoration ?? TextDecoration.none,
        fontStyle: fontStyle ?? FontStyle.normal,
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: fontSize ?? 14,
      ),
    );
  }
}
