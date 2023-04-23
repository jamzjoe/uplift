import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import '../../../constant/constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserIsIn) {
          context.goNamed('auth_wrapper');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/login-bg.png"),
                    fit: BoxFit.cover)),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 25, right: 30, left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: whiteColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(60)),
                        child: const DefaultText(
                            text: 'Sign In ', color: whiteColor),
                      )
                    ],
                  ),
                ),
                defaultSpace,
                Padding(
                  padding:
                      const EdgeInsets.only(right: 30, left: 30, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HeaderText(
                        text: 'Sign in to your\nAccount',
                        color: whiteColor,
                        size: 30,
                      ),
                      SizedBox(height: 5),
                      DefaultText(
                          text: 'Sign in to your account.', color: whiteColor)
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(color: whiteColor),
                  //Forms
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const CustomField(
                              label: 'Username',
                            ),
                            defaultSpace,
                            const CustomField(label: 'Password'),
                            defaultSpace,
                            const DefaultText(
                                text: 'Forgot Password?', color: linkColor),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: DefaultText(
                                        text: 'Login', color: whiteColor),
                                  )),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                line(),
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: DefaultText(
                                      text: 'Or login with',
                                      color: secondaryColor),
                                ),
                                line(),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(GoogleSignInRequested());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 25),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: lightColor)),
                                    child: Row(
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              "assets/google-logo.png"),
                                          width: 25,
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        DefaultText(
                                            text: 'Google',
                                            color: secondaryColor),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 25),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: lightColor)),
                                  child: Row(
                                    children: const [
                                      Image(
                                        image: AssetImage(
                                            "assets/facebook-logo.png"),
                                        width: 25,
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      DefaultText(
                                          text: 'Facebook',
                                          color: secondaryColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(children: [
                            TextSpan(
                                text: "Don't have an account?",
                                style: defaultTextStyle),
                            TextSpan(text: ' Register', style: linkStyle)
                          ]))
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded line() {
    return Expanded(
      child: Container(
        color: secondaryColor.withOpacity(0.2),
        height: 1,
      ),
    );
  }
}
