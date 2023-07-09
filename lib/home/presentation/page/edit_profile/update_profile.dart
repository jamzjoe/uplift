import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/custom_field.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

import '../tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, required this.currentUser});
  final UserJoinedModel currentUser;
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

File? file;
final _formKey = GlobalKey<FormState>();
String? name, email, contact, bio;

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      closeOnBackButton: true,
      child: Scaffold(
          appBar: AppBar(
            title: const HeaderText(
                text: 'Update Profile', color: darkColor, size: 16),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 3),
                      child: file != null
                          ? GestureDetector(
                              onTap: () async {
                                PrayerRequestRepository()
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
                              onTap: () async {
                                PrayerRequestRepository()
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
                                  user: widget.currentUser.userModel,
                                  size: 80,
                                  radius: 60)),
                    ),
                    CustomField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      initialValue: widget.currentUser.userModel.displayName,
                      hintText: 'Enter your display name',
                      validator: (p0) =>
                          p0!.isEmpty ? "Please do not leave it blank." : null,
                      label: 'Display name',
                    ),
                    CustomField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      readOnly: true,
                      initialValue: widget.currentUser.userModel.emailAddress,
                      hintText: 'Enter your email address',
                      validator: (p0) =>
                          p0!.isEmpty ? "Please do not leave it blank." : null,
                      label: 'Email address',
                    ),
                    CustomField(
                      onChanged: (value) {
                        setState(() {
                          contact = value;
                        });
                      },
                      initialValue:
                          widget.currentUser.userModel.phoneNumber ?? '+63',
                      hintText: 'Enter your contact number',
                      validator: (p0) =>
                          p0!.isEmpty ? "Please do not leave it blank." : null,
                      label: 'Contact number',
                    ),
                    CustomField(
                      onChanged: (value) {
                        setState(() {
                          bio = value;
                        });
                      },
                      initialValue: widget.currentUser.userModel.bio ?? '',
                      hintText: 'Enter your bio here',
                      validator: (p0) =>
                          p0!.isEmpty ? "Please do not leave it blank." : null,
                      label: 'Your bio',
                    ),
                    defaultSpace,
                    CustomContainer(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              if (file != null) {
                                final value =
                                    await AuthRepository().uploadProfilePicture(
                                  file!,
                                  widget.currentUser.userModel.userId!,
                                );
                                widget.currentUser.userModel.photoUrl = value;
                                setState(() {
                                  file = null;
                                });
                              }

                              final userModel = widget.currentUser.userModel;
                              final displayname = userModel.displayName;
                              final userBio = userModel.bio;
                              final emailAddress = userModel.emailAddress;
                              final contactNo = userModel.phoneNumber;
                              String? updatedName = name ?? displayname;
                              String? updatedBio = bio ?? userBio;
                              String? updatedEmail = email ?? emailAddress;
                              String? updatedPhone = contact ?? contactNo;

                              if (context.mounted) {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  UpdateProfile(
                                    displayName: updatedName!,
                                    emailAddress: updatedEmail!,
                                    contactNo: updatedPhone!,
                                    bio: updatedBio!,
                                    userID: userModel.userId!,
                                    context: context,
                                  ),
                                );

                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  SignIn(widget.currentUser),
                                );
                              }
                            } catch (e) {
                              // Handle any potential exceptions here
                              log('Error: $e');
                            } finally {
                              
                            }
                          }
                        },
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        widget: const Center(
                          child: DefaultText(
                              text: 'Confirm changes', color: whiteColor),
                        ),
                        color: primaryColor)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
