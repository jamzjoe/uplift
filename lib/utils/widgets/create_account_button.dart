import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    super.key,
    required this.goTo,
  });
  final String goTo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: TextButton(
              onPressed: () {
                context.pushNamed('auth-wrapper');
              },
              child: const SmallText(
                  text: "Continue with Email and Password",
                  color: primaryColor))),
    );
  }
}
