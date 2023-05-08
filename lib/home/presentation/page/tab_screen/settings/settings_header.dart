import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/count_details.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class SettingsProfileHeader extends StatefulWidget {
  const SettingsProfileHeader({super.key, required this.userJoinedModel});

  final UserJoinedModel userJoinedModel;

  @override
  State<SettingsProfileHeader> createState() => _SettingsProfileHeaderState();
}

bool isEditable = false;

class _SettingsProfileHeaderState extends State<SettingsProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final user = widget.userJoinedModel.user;
    final userModel = widget.userJoinedModel.userModel;
    return Container(
      padding: const EdgeInsets.all(20),
      color: whiteColor,
      child: Column(
        children: [
          Row(
            children: [
              ProfilePhoto(user: user),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: user.displayName ?? 'Anonymous User',
                    color: secondaryColor,
                    size: 18,
                  ),
                  Row(
                    children: [
                      SmallText(text: user.email!, color: lightColor),
                      const SizedBox(width: 5),
                      GestureDetector(
                          onTap: () =>
                              context.pushNamed('qr_generator2', extra: user),
                          child: const Icon(Ionicons.qr_code,
                              size: 15, color: lightColor))
                    ],
                  ),
                ],
              )
            ],
          ),
          defaultSpace,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CountAndName(
                  count: 291,
                  details: 'Prayer Request',
                ),
                VerticalDivider(),
                CountAndName(details: 'Followers', count: 300),
                VerticalDivider(),
                CountAndName(details: 'Following', count: 809)
              ],
            ),
          ),
          defaultSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomContainer(
                  onTap: () => context.pushNamed('edit-profile',
                      extra: widget.userJoinedModel),
                  widget: const SmallText(
                      text: 'Edit profile', color: secondaryColor),
                  color: secondaryColor.withOpacity(0.1)),
            ],
          ),
          defaultSpace,
          Visibility(
            visible: userModel.bio!.isEmpty,
            child: !isEditable
                ? TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isEditable = !isEditable;
                      });
                    },
                    icon: const Icon(Ionicons.add),
                    label: const DefaultText(
                        text: 'Add bio', color: secondaryColor))
                : TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    onFieldSubmitted: (value) {
                      setState(() {
                        isEditable = !isEditable;
                      });
                    },
                    onTapOutside: (value) {
                      setState(() {
                        isEditable = !isEditable;
                      });
                    },
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    maxLength: 40,
                    decoration: const InputDecoration(
                        hintText: 'Write your bio here...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 100),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                  ),
          ),
          Visibility(
            visible: userModel.bio!.isNotEmpty,
            child: GestureDetector(
              onTap: () => log('Update bio'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  DefaultText(text: 'Bio', color: secondaryColor),
                  SmallText(text: 'Edit bio', color: linkColor)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
