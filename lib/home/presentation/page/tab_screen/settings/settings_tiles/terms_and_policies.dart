import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class TermAndPoliciesScreen extends StatelessWidget {
  const TermAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const HeaderText(text: 'Term and policies', color: secondaryColor),
      ),
    );
  }
}
