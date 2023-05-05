import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';

import 'default_text.dart';

class NoDataMessage extends StatelessWidget {
  const NoDataMessage({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: DefaultText(text: text, color: lightColor),
    );
  }
}
