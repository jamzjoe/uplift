import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../constant/constant.dart';
import '../../../../utils/widgets/header_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.user});
  final User user;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      appBar: AppBar(
        title: const HeaderText(text: 'Settings', color: secondaryColor),
        actions: [
          IconButton(
            icon: IconButton(
                onPressed: () {}, icon: const Icon(Ionicons.pencil_outline)),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: whiteColor,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        const Icon(Ionicons.qr_code,
                            size: 15, color: lightColor)
                      ],
                    ),
                  ],
                )
              ],
            ),
            defaultSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CountAndName(
                  count: 291,
                  details: 'Prayer Reuest',
                ),
                VerticalDivider(
                  color: secondaryColor,
                ),
                CountAndName(details: 'Followers', count: 300),
                VerticalDivider(
                  color: secondaryColor,
                ),
                CountAndName(details: 'Following', count: 809)
              ],
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
                label:
                    const DefaultText(text: 'Add bio', color: secondaryColor))
          ],
        ),
      ),
    );
  }
}

class CountAndName extends StatelessWidget {
  const CountAndName({
    super.key,
    required this.details,
    required this.count,
  });
  final String details;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderText(text: count.toString(), color: secondaryColor),
        SmallText(text: details, color: lightColor)
      ],
    );
  }
}
