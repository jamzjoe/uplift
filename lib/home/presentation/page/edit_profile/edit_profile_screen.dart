import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
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

final TextEditingController nameController = TextEditingController();
final TextEditingController contactController = TextEditingController();
final TextEditingController bioController = TextEditingController();
final TextEditingController emailAddressController = TextEditingController();
File? file;
String? imageURL;

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    final user = widget.userJoinedModel.userModel;
    nameController.text = user.displayName!;
    contactController.text = user.phoneNumber ?? '';
    bioController.text = (user.bio ?? '');
    emailAddressController.text = user.emailAddress!;
    contactController.text = '+63';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userJoinedModel.userModel;
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const HeaderText(text: 'Edit profile', color: darkColor),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(seconds: 3),
                  child: file != null
                      ? GestureDetector(
                          onTap: () {
                            pickProfilePhoto()
                                .imagePicker()
                                .then((value) async {
                              final picked = await PrayerRequestRepository()
                                  .xFileToFile(value!);
                              setState(() {
                                file = picked;
                              });
                            });
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(file!),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            pickProfilePhoto()
                                .imagePicker()
                                .then((value) async {
                              final picked = await PrayerRequestRepository()
                                  .xFileToFile(value!);
                              setState(() {
                                file = picked;
                              });
                            });
                          },
                          child:
                              ProfilePhoto(user: user, size: 80, radius: 60)),
                ),
                defaultSpace,
                CustomField(
                  hintText: 'Enter your display name',
                  label: 'Display name',
                  controller: nameController,
                ),
                Tooltip(
                  message: "Email address cannot be change.",
                  child: CustomField(
                      readOnly: true,
                      controller: emailAddressController,
                      label: 'Email address ⓘ',
                      hintText: 'Add email address'),
                ),
                CustomField(
                  hintText: '+63900-000-0000',
                  label: 'Contact no.',
                  limit: 13,
                  controller: contactController,
                ),
                CustomField(
                  limit: 150,
                  hintText: 'Write your bio here...',
                  label: 'Bio',
                  controller: bioController,
                ),
                defaultSpace,
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(10),
          height: 65,
          child: Center(
            child: CustomContainer(
                onTap: () async {
                  context.loaderOverlay.show();
                  UserJoinedModel userJoinedModel = widget.userJoinedModel;
                  if (file != null) {
                    imageURL = await AuthRepository()
                        .uploadProfilePicture(file!, user.userId!)
                        .then((value) {
                      userJoinedModel.userModel.photoUrl = value;
                    }).whenComplete(() {
                      setState(() {
                        file = null;
                      });
                    });
                  }

                  userJoinedModel.userModel.displayName = nameController.text;
                  userJoinedModel.userModel.bio = bioController.text;
                  userJoinedModel.userModel.emailAddress =
                      emailAddressController.text;
                  userJoinedModel.userModel.phoneNumber =
                      contactController.text;

                  if (context.mounted) {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                        UpdateProfile(
                            displayName: nameController.text,
                            emailAddress: emailAddressController.text,
                            contactNo: contactController.text,
                            bio: bioController.text,
                            userID: user.userId!,
                            context: context));

                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(SignIn(userJoinedModel));
                  }
                },
                widget: const Center(
                    child: DefaultText(
                        text: 'Confirm Changes', color: whiteColor)),
                color: primaryColor),
          ),
        ),
      ),
    );
  }

  PrayerRequestRepository pickProfilePhoto() => PrayerRequestRepository();
}
