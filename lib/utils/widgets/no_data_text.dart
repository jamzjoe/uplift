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
          Transform.scale(
              scale: text == 'No prayer intention found.' ? 1.2 : 1.5,
              child: Lottie.asset(
                  text == 'No prayer intention found.'
                      ? 'assets/no-data.json'
                      : 'assets/no-user.json',
                  width: 200)),
          defaultSpace,
          DefaultText(text: text, color: lightColor),
        ],
      ),
    );
  }
}
