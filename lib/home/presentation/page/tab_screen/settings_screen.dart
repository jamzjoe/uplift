import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsProfileHeader(user: user),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DefaultText(text: 'Login', color: secondaryColor),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: ListTile.divideTiles(
                            context: context,
                            tiles: [const SettingsItem(), const SettingsItem()])
                        .toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => logOutUser(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.square_arrow_left_fill,
                  color: secondaryColor.withOpacity(0.8),
                ),
                const SizedBox(width: 15),
                const DefaultText(text: 'Logout', color: secondaryColor),
              ],
            ),
            Icon(CupertinoIcons.chevron_forward,
                color: secondaryColor.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }

  void logOutUser(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(SignOutRequested());
  }
}

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
                      const Icon(Ionicons.qr_code, size: 15, color: lightColor)
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
              label: const DefaultText(text: 'Add bio', color: secondaryColor)),
        ],
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
