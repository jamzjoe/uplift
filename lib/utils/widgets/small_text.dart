import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  const SmallText(
      {super.key, required this.text, required this.color, this.textAlign, this.fontStyle});
  final String text;
  final Color color;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontStyle: fontStyle ?? FontStyle.normal,
        color: color,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
    );
  }
}
