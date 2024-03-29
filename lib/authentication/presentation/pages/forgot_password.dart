import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import '../../../utils/widgets/small_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultText(text: 'Forgot password', color: darkColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: [
            SmallText(
                text:
                    'Please provide the email address that is currently associated with your UpLift account.',
                color: lighter),
            const SizedBox(height: 10),
            CustomField(
              controller: emailController,
              hintText: 'Your email address here...',
              label: 'Email Address',
            ),
            CustomContainer(
                onTap: () {
                  _sendPasswordResetRequest();
                },
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                widget: const Center(
                    child: DefaultText(text: 'Submit', color: whiteColor)),
                color: primaryColor)
          ],
        ),
      ),
    );
  }

  void _sendPasswordResetRequest() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: emailController.text,
      )
          .whenComplete(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Password Reset'),
              content: const Text('Password reset email has been sent.'),
              actions: [
                CustomContainer(
                    onTap: () {
                      context.pop();
                    },
                    widget: const SmallText(text: "Confirm", color: whiteColor),
                    color: primaryColor)
              ],
            );
          },
        );
      });
      // Password reset email sent successfully
    } catch (e) {
      log(e.toString());
      // Error occurred while sending password reset email
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred. Please try again later.'),
            actions: [
              CustomContainer(
                  onTap: () => context.pop(),
                  widget: const SmallText(text: "Okay", color: whiteColor),
                  color: primaryColor)
            ],
          );
        },
      );
    }
  }
}
