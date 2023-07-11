import 'package:flutter/material.dart';
import 'package:uplift/authentication/presentation/domain/introduction_repository.dart';
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
    return Center(
        child: TextButton(
            onPressed: () {
              if (goTo == 'register') {
                IntroductionRepository().goToRegister(context);
              } else {
                IntroductionRepository().goToLogin(context);
              }
            },
            child: const SmallText(
                text: "Continue with Email and Password",
                color: primaryColor)));
  }
}
