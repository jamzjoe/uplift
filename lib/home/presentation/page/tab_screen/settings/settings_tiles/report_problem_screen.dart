import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_tiles/problem_list_tile.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class ReportAProblemScreen extends StatelessWidget {
  const ReportAProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Report a problem', color: darkColor),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        children: [
          CustomContainer(
            color: Colors.grey.shade100,
            widget: TextFormField(
              decoration: const InputDecoration(
                  suffixIcon: Icon(Ionicons.arrow_forward_circle),
                  hintText: 'What is your problem?',
                  border: InputBorder.none),
            ),
          ),
          const ProblemListTile(
            problem: 'Difficulty creating an account or logging in',
            solution: 'Make sure your email address is a valid email address.',
          ),
          const ProblemListTile(
            problem: 'Forgotten or lost login credentials',
            solution:
                "Click on the 'Forgot Password' link on the login page and follow the instructions to reset your password",
          ),
          const ProblemListTile(
            problem: 'Account security concerns',
            solution:
                'Implement strong password requirements and enable two-factor authentication for enhanced account security.',
          ),
          const ProblemListTile(
            problem: 'Unauthorized access or account breaches',
            solution:
                'Regularly monitor user accounts for suspicious activities and promptly investigate any reported incidents.',
          ),
          const ProblemListTile(
            problem: 'Privacy concerns and data protection',
            solution:
                "Clearly communicate the app's privacy policy and implement robust data protection measures.",
          ),
          const ProblemListTile(
            problem: 'Account deletion or deactivation',
            solution:
                "Go to ${"Settings"} tab and locate delete. \n Note:  We cannot recover your account once its deleted.",
          ),
        ],
      ),
    );
  }
}
