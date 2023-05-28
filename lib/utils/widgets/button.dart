import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key,
      required this.widget,
      required this.color,
      this.onTap,
      this.width,
      this.padding,
      this.margin});
  final Widget widget;
  final Color color;
  final VoidCallback? onTap;
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: width,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
            color: color,
            border:
                Border.all(color: secondaryColor.withOpacity(0.2), width: 0.5),
            borderRadius: BorderRadius.circular(15)),
        child: widget,
      ),
    );
  }
}
