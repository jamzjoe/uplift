import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class ReportAProblemScreen extends StatelessWidget {
  const ReportAProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const HeaderText(text: 'Report a problem', color: secondaryColor),
      ),
    );
  }
}
