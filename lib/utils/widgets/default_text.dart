import 'package:flutter/material.dart';

class DefaultText extends StatelessWidget {
  const DefaultText(
      {super.key, required this.text, required this.color, this.textAlign});
  final String text;
  final Color color;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style:
          TextStyle(color: color, fontWeight: FontWeight.normal, fontSize: 16),
    );
  }
}
