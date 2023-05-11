import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userJoinedModel});

  final UserJoinedModel userJoinedModel;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

TextEditingController? nameController;
TextEditingController? contactController;
TextEditingController? bioController;

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = widget.userJoinedModel.userModel;
    nameController = TextEditingController(text: user.displayName ?? '');
    contactController = TextEditingController(text: user.phoneNumber ?? '');
    bioController = TextEditingController(text: user.bio ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Edit profile', color: secondaryColor),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Column(
            children: [
              ProfilePhoto(user: user, size: 80, radius: 60),
              defaultSpace,
              CustomField(
                hintText: 'Enter your display name',
                label: 'Display name',
                controller: nameController,
              ),
              CustomField(
                hintText: '+63900-000-0000',
                label: 'Contact no.',
                controller: contactController,
              ),
              CustomField(
                hintText: 'Write your bio here...',
                label: 'Bio',
                controller: bioController,
              ),
              defaultSpace,
              const CustomContainer(
                  widget: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: DefaultText(
                            text: 'Confirm Changes', color: whiteColor)),
                  ),
                  color: primaryColor)
            ],
          ),
        ),
      ),
    );
  }
}
