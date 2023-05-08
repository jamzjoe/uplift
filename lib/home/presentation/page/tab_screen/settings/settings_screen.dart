import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/dialog.dart';

import '../../../../../constant/constant.dart';
import '../../../../../utils/widgets/header_text.dart';
import 'settings_header.dart';
import 'settings_item.dart';
import 'settings_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.userJoinedModel});
  final UserJoinedModel userJoinedModel;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = widget.userJoinedModel.user;
    final UserModel anotherInfo = widget.userJoinedModel.userModel;
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          SettingsProfileHeader(
            userJoinedModel: widget.userJoinedModel,
          ),
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              SettingsSection(
                title: 'Account',
                widget: Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: ListTile.divideTiles(context: context, tiles: [
                      SettingsItem(
                          onTap: () => context.pushNamed('account'),
                          label: 'Account',
                          icon: CupertinoIcons.person_fill),
                      SettingsItem(
                          onTap: () => context.pushNamed('privacy'),
                          label: 'Privacy',
                          icon: CupertinoIcons.lock_fill),
                      SettingsItem(
                          onTap: () => context.pushNamed('security'),
                          label: 'Security',
                          icon: CupertinoIcons.shield_fill),
                      const SettingsItem(
                          label: 'Share Profile',
                          icon: CupertinoIcons.arrowshape_turn_up_right_fill)
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
                      children: ListTile.divideTiles(context: context, tiles: [
                        SettingsItem(
                            onTap: () => context.pushNamed('donate'),
                            label: 'Donate and Support Us',
                            icon: CupertinoIcons.heart_fill),
                        SettingsItem(
                            onTap: () => context.pushNamed('report-problem'),
                            label: 'Report a problem',
                            icon: CupertinoIcons.flag_fill),
                        SettingsItem(
                            onTap: () => context.pushNamed('support'),
                            label: 'Support',
                            icon: CupertinoIcons.chat_bubble_fill),
                        SettingsItem(
                            onTap: () => context.pushNamed('term-policies'),
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
                    children: ListTile.divideTiles(context: context, tiles: [
                      SettingsItem(
                          onTap: () => customDialog(
                                  context,
                                  'This will delete your account.',
                                  'Delete confirmation', [
                                TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const DefaultText(
                                        text: 'Cancel', color: secondaryColor)),
                                TextButton(
                                    onPressed: () {
                                      
                                    },
                                    child: const DefaultText(
                                        text: 'Delete', color: Colors.red)),
                              ]),
                          label: 'Delete Account',
                          icon: CupertinoIcons.delete_left_fill),
                      SettingsItem(
                          onTap: signOutWarning,
                          label: 'Logout',
                          icon: CupertinoIcons.square_arrow_left_fill)
                    ]).toList(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void signOutWarning() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const DefaultText(
                  text: 'Logout Confirmation', color: secondaryColor),
              actions: [
                CustomContainer(
                    onTap: () => context.pop(),
                    widget:
                        const DefaultText(text: 'Cancel', color: Colors.red),
                    color: Colors.transparent),
                CustomContainer(
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(SignOutRequested());
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    widget:
                        const DefaultText(text: 'Confirm', color: whiteColor),
                    color: primaryColor),
              ],
            ));
  }
}
