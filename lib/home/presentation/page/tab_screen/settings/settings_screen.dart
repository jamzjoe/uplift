import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';

import '../../../../../constant/constant.dart';
import '../../../../../utils/widgets/header_text.dart';
import 'settings_header.dart';
import 'settings_item.dart';
import 'settings_section.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsProfileHeader(user: user),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  SettingsSection(
                    title: 'Account',
                    widget: Container(
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          const SettingsItem(
                              label: 'Account',
                              icon: CupertinoIcons.person_fill),
                          const SettingsItem(
                              label: 'Privacy', icon: CupertinoIcons.lock_fill),
                          const SettingsItem(
                              label: 'Security',
                              icon: CupertinoIcons.shield_fill),
                          const SettingsItem(
                              label: 'Share Profile',
                              icon:
                                  CupertinoIcons.arrowshape_turn_up_right_fill)
                        ]).toList(),
                      ),
                    ),
                  ),
                  SettingsSection(
                      title: 'Support & About',
                      widget: Container(
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children:
                              ListTile.divideTiles(context: context, tiles: [
                            const SettingsItem(
                                label: 'Donate and Support Us',
                                icon: CupertinoIcons.heart_fill),
                            const SettingsItem(
                                label: 'Report a problem',
                                icon: CupertinoIcons.flag_fill),
                            const SettingsItem(
                                label: 'Support',
                                icon: CupertinoIcons.chat_bubble_fill),
                            const SettingsItem(
                                label: 'Terms and Policies',
                                icon: CupertinoIcons.info_circle_fill),
                          ]).toList(),
                        ),
                      )),
                  SettingsSection(
                    title: 'Login',
                    widget: Container(
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          const SettingsItem(
                              label: 'Switch Account',
                              icon: CupertinoIcons
                                  .arrow_right_arrow_left_square_fill),
                          SettingsItem(
                              onTap: () =>
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(SignOutRequested()),
                              label: 'Logout',
                              icon: CupertinoIcons.square_arrow_left_fill)
                        ]).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
