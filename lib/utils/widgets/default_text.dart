import 'package:flutter/material.dart';

class DefaultText extends StatelessWidget {
  const DefaultText({super.key, required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontWeight: FontWeight.normal, fontSize: 16),
    );
  }
}
