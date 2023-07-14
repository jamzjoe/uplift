import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../constant/constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>(debugLabel: 'login');
  bool hidePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext _) {
    return LoaderOverlay(
      closeOnBackButton: true,
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: primaryColor,
                  expandedHeight: 200,
                  automaticallyImplyLeading: false, // Hide the back button
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
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
                                    text: 'Login Account',
                                    color: whiteColor,
                                    size: 30,
                                  ),
                                  SizedBox(height: 5),
                                  DefaultText(
                                    overflow: TextOverflow.clip,
                                    text:
                                        'Connect with a community of faith and uplift one another.',
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Image(
                              image: AssetImage('assets/auth_bg.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(color: whiteColor),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomField(
                            hintText: "Enter your valid email address",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email address is required';
                              } else if (!AuthServices.isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            controller: _emailController,
                            label: 'Email Address',
                          ),
                          CustomField(
                            hintText: 'Password must be at least 6 characters',
                            maxLine: 1,
                            isPassword: hidePassword,
                            tapSuffix: () => setState(() {
                              hidePassword = !hidePassword;
                            }),
                            suffixIcon: !hidePassword
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            validator: (p0) =>
                                p0!.length < 6 ? 'Password too short.' : null,
                            label: 'Password',
                            controller: _passwordController,
                          ),
                          GestureDetector(
                            onTap: () => context.pushNamed('forgotPassword'),
                            child: const SmallText(
                              text: 'Forgot password?',
                              color: linkColor,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    SignInWithEmailAndPassword(
                                      _emailController,
                                      _passwordController,
                                      '',
                                      context,
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          ? 'Login'
                                          : 'Logging in...',
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  text: 'Or login with',
                                  color: lighter,
                                ),
                              ),
                              line(),
                            ],
                          ),
                          defaultSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    GoogleSignInRequested('', context, true),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 25,
                                  ),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                                        text: 'Google',
                                        color: lighter,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
