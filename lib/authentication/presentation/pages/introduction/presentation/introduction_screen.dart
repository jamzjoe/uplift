import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/router/router.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import '../../../bloc/authentication/authentication_bloc.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

bool isLoading = false;

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Image(
                image: AssetImage('assets/uplift-logo.png'),
                width: 100,
              ),
              const SizedBox(height: 5),
              const SmallText(
                textAlign: TextAlign.center,
                text: 'Spreading Light, One Prayer at a Time',
                color: secondaryColor,
              ),
              GestureDetector(
                onTap: () async {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(GoogleSignInRequested('', context, false));
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  shrinkWrap: true,
                  children: [
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage("assets/google-logo.png"),
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 15),
                            DefaultText(
                                text: 'Continue with Google',
                                color: secondaryColor),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: goToLogin,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            SizedBox(),
                            DefaultText(
                                text: 'Continue in another way',
                                color: secondaryColor),
                            SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }

  void goToLogin() {
    router.pushNamed('login');
  }
}
