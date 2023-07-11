import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/presentation/domain/introduction_repository.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../constant/constant.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomContainer(
          widget: TextButton.icon(
              onPressed: () async {
                IntroductionRepository().googleLogin(context);
              },
              icon: const Icon(Ionicons.logo_google, color: whiteColor),
              label: const SmallText(
                  text: "Sign-in with google", color: whiteColor)),
          color: primaryColor),
    );
  }
}
