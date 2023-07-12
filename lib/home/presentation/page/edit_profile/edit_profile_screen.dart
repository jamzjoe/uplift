import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/edit_profile/update_profile/update_profile_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.userJoinedModel})
      : super(key: key);

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
final _formKey = GlobalKey<FormState>();

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    final user = widget.userJoinedModel.userModel;
    nameController.text = user.displayName ?? '';
    bioController.text = (user.bio ?? '');
    emailAddressController.text = user.emailAddress ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userJoinedModel.userModel;

    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Edit profile', color: darkColor),
      ),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(SignIn(state.userJoinedModel));
            CustomDialog.showCustomSnackBar(
                context, 'Profile updated successfully');
          }
        },
        builder: (context, state) {
          if (state is UpdateProfileLoading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeBounce(color: primaryColor, size: 30),
                  SizedBox(height: 5),
                  DefaultText(
                      text: 'Updating your profile information',
                      color: primaryColor)
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Form(
                key: _formKey,
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
                              child: ProfilePhoto(
                                  user: user, size: 80, radius: 60),
                            ),
                    ),
                    defaultSpace,
                    CustomField(
                      hintText: 'Enter your display name',
                      validator: (p0) =>
                          p0!.isEmpty ? "Please do not leave it blank." : null,
                      label: 'Display name',
                      controller: nameController,
                    ),
                    Tooltip(
                      message: "Email address cannot be changed.",
                      child: CustomField(
                        readOnly: true,
                        controller: emailAddressController,
                        label: 'Email address ⓘ',
                        hintText: 'Add email address',
                      ),
                    ),
                    defaultSpace,
                    IntlPhoneField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'PH',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    CustomField(
                      limit: 250,
                      validator: (p0) =>
                          p0!.isEmpty ? "Please do not leave it blank." : null,
                      hintText: 'Write your bio here...',
                      label: 'Bio',
                      controller: bioController,
                    ),
                    defaultSpace,
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 65,
                      child: Center(
                        child: CustomContainer(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<UpdateProfileBloc>(context).add(
                                  UpdateProfileInformationEvent(
                                      displayName: nameController.text,
                                      emailAddress: emailAddressController.text,
                                      contactNo: contactController.text,
                                      bio: bioController.text,
                                      userID: widget.userJoinedModel.user.uid));
                            }
                          },
                          widget: const Center(
                            child: DefaultText(
                                text: 'Confirm Changes', color: whiteColor),
                          ),
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PrayerRequestRepository pickProfilePhoto() => PrayerRequestRepository();
}
