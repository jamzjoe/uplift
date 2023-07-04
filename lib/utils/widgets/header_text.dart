import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText(
      {super.key,
      required this.text,
      required this.color,
      this.size,
      this.onTap,
      this.textAlign,
      this.overflow});

  final String text;
  final double? size;
  final TextOverflow? overflow;
  final Color color;
  final VoidCallback? onTap;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    double fontSize = size ?? 20;

    // Check if the device is a tablet
    if (MediaQuery.of(context).size.shortestSide >= 600) {
      fontSize += 2;
    }

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: fontSize,
          overflow: overflow ?? TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
