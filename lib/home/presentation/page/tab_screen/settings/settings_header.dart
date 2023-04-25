import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/count_details.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: whiteColor,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: user.displayName!,
                    color: secondaryColor,
                    size: 18,
                  ),
                  Row(
                    children: [
                      SmallText(text: user.email!, color: lightColor),
                      const SizedBox(width: 5),
                      GestureDetector(
                          onTap: () =>
                              context.pushNamed('qr_generator', extra: user),
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
              CustomButton(
                  widget: const SmallText(
                      text: 'Edit profile', color: secondaryColor),
                  color: secondaryColor.withOpacity(0.1)),
              const SizedBox(width: 15),
              CustomButton(
                  widget: const SmallText(
                      text: 'Add friends', color: secondaryColor),
                  color: secondaryColor.withOpacity(0.1)),
            ],
          ),
          defaultSpace,
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Ionicons.add),
              label: const DefaultText(text: 'Add bio', color: secondaryColor)),
        ],
      ),
    );
  }
}
