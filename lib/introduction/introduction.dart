import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/router/router.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 60),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Image(
              image: AssetImage('assets/uplift-logo.png'),
              width: 100,
            ),
            defaultSpace,
            const HeaderText(text: "Welcome Back!", color: secondaryColor),
            const DefaultText(
                text: 'Last time you use google to log in.',
                color: secondaryColor),
            SizedBox(height: MediaQuery.of(context).size.height - 650),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Image(
                    image: AssetImage("assets/google-logo.png"),
                    width: 25,
                    height: 25,
                  ),
                  DefaultText(
                      text: 'Continue with Google', color: secondaryColor),
                  SizedBox()
                ],
              ),
            ),
            defaultSpace,
            GestureDetector(
              onTap: goToLogin,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SizedBox(),
                    DefaultText(
                        text: 'Continue in another way', color: secondaryColor),
                    SizedBox()
                  ],
                ),
              ),
            ),
            defaultSpace,
            RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                      text: 'By continuing you agree to UpLift',
                      style: defaultTextStyle),
                  TextSpan(text: ' Terms of Use.', style: linkStyle),
                  TextSpan(text: ' Read our', style: defaultTextStyle),
                  TextSpan(text: ' Privacy Policy.', style: linkStyle),
                ]))
          ],
        ),
      ),
    );
  }

  void goToLogin() {
    router.goNamed('auth');
  }
}
