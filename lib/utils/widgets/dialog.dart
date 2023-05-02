import 'package:flutter/material.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';

import 'default_text.dart';
import 'header_text.dart';

Future<dynamic> customDialog(
    BuildContext context, UserIsOut state, String title, List<Widget> actions) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: HeaderText(text: title, color: secondaryColor),
            content: DefaultText(text: state.message, color: secondaryColor),
            actions: actions,
          ));
}
