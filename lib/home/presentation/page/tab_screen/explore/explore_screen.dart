import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const HeaderText(text: 'Explore', color: secondaryColor)),
    );
  }
}
