import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:lottie/lottie.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/no-data.json', width: 200),
          DefaultText(text: text, color: lightColor),
        ],
      ),
    );
  }
}
