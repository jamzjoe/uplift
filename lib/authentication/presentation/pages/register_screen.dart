import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool isLoading = false;
  bool hidePassword = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserIsIn) {
          _emailController.clear();
          _passwordController.clear();
        } else if (state is Loading) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
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
                defaultSpace,
                Padding(
                  padding:
                      const EdgeInsets.only(right: 30, left: 30, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HeaderText(
                        text: 'Create UpLift\nNew Account',
                        color: whiteColor,
                        size: 30,
                      ),
                      SizedBox(height: 5),
                      DefaultText(
                          text: 'Create new uplift new account.',
                          color: whiteColor)
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
                                  const Flexible(
                                    child: SmallText(
                                        text:
                                            'Agrees to the Terms and Condition and Privacy Policy',
                                        color: secondaryColor),
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
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  '',
                                                  _userNameController.text));
                                        }
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: isLoading,
                                          child: const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: DefaultText(
                                              text: !isLoading
                                                  ? 'Create Account'
                                                  : 'Creating UpLift Account',
                                              color: whiteColor),
                                        ),
                                      ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(const GoogleSignInRequested(''));
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
                                        border: Border.all(
                                            color:
                                                lightColor.withOpacity(0.2))),
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
                        defaultSpace,
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              const TextSpan(
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
        color: secondaryColor.withOpacity(0.2),
        height: 1,
      ),
    );
  }
}
