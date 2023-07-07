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
      this.margin,
      this.borderWidth,
      this.borderColor});
  final Widget widget;
  final Color color;
  final VoidCallback? onTap;
  final double? width;
  final EdgeInsets? padding;
  final double? borderWidth;
  final EdgeInsets? margin;
  final Color? borderColor;
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
            border: borderWidth == null
                ? null
                : Border.all(
                    width: 1,
                    color: borderColor == null
                        ? darkColor.withOpacity(0.4)
                        : borderColor!.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withOpacity(0.3), // Color and opacity of the shadow
                spreadRadius: 1, // Spread radius of the shadow
                blurRadius: 2, // Blur radius of the shadow
                offset: const Offset(0, 2), // Offset of the shadow
              ),
            ],
            color: color,
            borderRadius: BorderRadius.circular(15)),
        child: widget,
      ),
    );
  }
}
