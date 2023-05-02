import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import '../../../utils/widgets/small_text.dart';

class ForgrotPasswordScreen extends StatefulWidget {
  const ForgrotPasswordScreen({super.key});

  @override
  State<ForgrotPasswordScreen> createState() => _ForgrotPasswordScreenState();
}

class _ForgrotPasswordScreenState extends State<ForgrotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const DefaultText(text: 'Forgot password', color: secondaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: const [
            SmallText(
                text:
                    'Please provide the email address that is currently associated with your UpLift account.',
                color: secondaryColor),
            SizedBox(height: 10),
            CustomField(
              hintText: 'Your email address here...',
              label: 'Email Address',
            ),
            CustomContainer(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                widget: Center(
                    child: DefaultText(text: 'Submit', color: whiteColor)),
                color: primaryColor)
          ],
        ),
      ),
    );
  }
}
