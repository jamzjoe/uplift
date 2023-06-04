import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText(
      {super.key,
      required this.text,
      required this.color,
      this.size,
      this.onTap,
      this.textAlign});
  final String text;
  final double? size;
  final Color color;
  final VoidCallback? onTap;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: size ?? 24,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
