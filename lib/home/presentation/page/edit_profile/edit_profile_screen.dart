import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/header_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userJoinedModel});

  final UserJoinedModel userJoinedModel;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

final TextEditingController nameController = TextEditingController();

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = widget.userJoinedModel.user;
    TextEditingController(text: user.displayName ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Edit profile', color: secondaryColor),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: [
            CustomField(
              label: 'Name',
              controller: nameController,
            ),
            CustomField(
              label: 'Name',
              controller: nameController,
            ),
            CustomField(
              label: 'Name',
              controller: nameController,
            ),
            CustomField(
              label: 'Name',
              controller: nameController,
            ),
            CustomField(
              label: 'Name',
              controller: nameController,
            ),
            CustomField(
              label: 'Name',
              controller: nameController,
            ),
          ],
        ),
      ),
    );
  }
}
