import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../constant/constant.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _userNameController = TextEditingController();

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 15, right: 30, left: 30),
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
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: MediaQuery.of(context).size.width < 768
                              ? const EdgeInsets.all(15)
                              : const EdgeInsets.all(30),
                          child: const Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeaderText(
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                text: 'Create Account',
                                color: whiteColor,
                                size: 30,
                              ),
                              SizedBox(height: 5),
                              DefaultText(
                                  overflow: TextOverflow.clip,
                                  text:
                                      'Connect with a community of faith and uplift one another.',
                                  color: whiteColor)
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: Image(image: AssetImage('assets/auth_bg.png')))
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(color: whiteColor),
                  //Forms
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: _key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomField(
                                validator: (p0) =>
                                    p0!.isEmpty ? 'Username is required' : null,
                                controller: _userNameController,
                                label: 'Username',
                              ),
                              CustomField(
                                validator: (p0) => p0!.isEmpty
                                    ? 'Email address is required'
                                    : null,
                                controller: _emailController,
                                label: 'Email Address',
                              ),
                              CustomField(
                                isPassword: hidePassword,
                                tapSuffix: () => setState(() {
                                  hidePassword = !hidePassword;
                                }),
                                suffixIcon: !hidePassword
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye,
                                validator: (p0) => p0!.length < 6
                                    ? 'Password too short.'
                                    : null,
                                label: 'Password',
                                controller: _passwordController,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      }),
                                  Flexible(
                                    child: SmallText(
                                        text:
                                            'Agrees to the Terms and Condition and Privacy Policy',
                                        color: lighter),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (isChecked == false) {
                                        CustomDialog.showErrorDialog(
                                            context,
                                            'In order to create your account, you need to consent to the terms and conditions as well as the privacy policy.',
                                            'Account Creation Agreement',
                                            'Confirm');
                                      } else {
                                        if (_key.currentState!.validate()) {
                                          BlocProvider.of<AuthenticationBloc>(
                                                  context)
                                              .add(RegisterWithEmailAndPassword(
                                                  _emailController,
                                                  _passwordController,
                                                  '',
                                                  _userNameController,
                                                  context));
                                        }
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: DefaultText(
                                          text: 'Creating UpLift Account',
                                          color: whiteColor),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  line(),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: DefaultText(
                                        text: 'Or login with', color: lighter),
                                  ),
                                  line(),
                                ],
                              ),
                              defaultSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(GoogleSignInRequested(
                                              '', context, true));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 25),
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color:
                                                  lightColor.withOpacity(0.2))),
                                      child: Row(
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                                "assets/google-logo.png"),
                                            width: 25,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          DefaultText(
                                              text: 'Google', color: lighter),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        defaultSpace,
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Already have an account?",
                                  style: defaultTextStyle),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.pop(),
                                  text: ' Login',
                                  style: linkStyle)
                            ]))
                      ],
                    ),
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
        color: lighter.withOpacity(0.2),
        height: 1,
      ),
    );
  }
}
