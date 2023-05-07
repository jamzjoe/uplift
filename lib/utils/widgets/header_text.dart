import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText(
      {super.key, required this.text, required this.color, this.size});
  final String text;
  final double? size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: size ?? 20,
          overflow: TextOverflow.clip),
    );
  }
}
