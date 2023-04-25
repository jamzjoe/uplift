import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class CountAndName extends StatelessWidget {
  const CountAndName({
    super.key,
    required this.details,
    required this.count,
  });
  final String details;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderText(text: count.toString(), color: secondaryColor),
        SmallText(text: details, color: lightColor)
      ],
    );
  }
}
