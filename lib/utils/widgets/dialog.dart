import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';

import 'default_text.dart';
import 'header_text.dart';

Future<dynamic> customDialog(
    BuildContext context, String text, String title, List<Widget> actions) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: HeaderText(text: title, color: secondaryColor),
            content: DefaultText(text: text, color: secondaryColor),
            actions: actions,
          ));
}
