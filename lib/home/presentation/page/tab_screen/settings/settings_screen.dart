import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/utils/widgets/pop_up.dart';

import '../../../../../constant/constant.dart';
import '../../../../../utils/widgets/header_text.dart';
import 'settings_header.dart';
import 'settings_item.dart';
import 'settings_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is UserIsIn) {
          final userJoinedModel = state.userJoinedModel;
          return Scaffold(
            backgroundColor: const Color(0xffF0F0F0),
            appBar: AppBar(
              title: const HeaderText(text: 'Settings', color: darkColor),
            ),
            body: ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                SettingsProfileHeader(
                  userJoinedModel: userJoinedModel,
                ),
                ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    SettingsSection(
                        title: 'Reminders',
                        widget: Container(
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children:
                                ListTile.divideTiles(context: context, tiles: [
                              SettingsItem(
                                  onTap: () => context.pushNamed('donate'),
                                  label: 'Set prayer intentions privacy',
                                  icon: CupertinoIcons.globe),
                            ]).toList(),
                          ),
                        )),
                    SettingsSection(
                      title: 'Account',
                      widget: Container(
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children:
                              ListTile.divideTiles(context: context, tiles: [
                            SettingsItem(
                                onTap: () => context.pushNamed('account'),
                                label: 'Account',
                                icon: CupertinoIcons.person_fill),
                            const SettingsItem(
                                label: 'Share Profile',
                                icon: CupertinoIcons
                                    .arrowshape_turn_up_right_fill)
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
                              SettingsItem(
                                  onTap: () => context.pushNamed('donate'),
                                  label: 'Donate and Support Us',
                                  icon: CupertinoIcons.heart_fill),
                              SettingsItem(
                                  onTap: () =>
                                      context.pushNamed('report-problem'),
                                  label: 'Report a problem',
                                  icon: CupertinoIcons.flag_fill),
                              SettingsItem(
                                  onTap: () => context.pushNamed('about-us'),
                                  label: 'About Us',
                                  icon: CupertinoIcons.info_circle_fill)
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
                            SettingsItem(
                                onTap: () =>
                                    CustomDialog.showDeleteConfirmation(
                                        context,
                                        'Are you sure you want to delete your account?',
                                        'Delete Confirmation', () {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(DeleteAccount(
                                              state.userJoinedModel.user));
                                      context.pop();
                                    }, 'Delete Account'),
                                label: 'Delete Account',
                                icon: CupertinoIcons.delete_left_fill),
                            SettingsItem(
                                onTap: () =>
                                    CustomDialog.showLogoutConfirmation(
                                        context,
                                        'Are you sure you want to logout?',
                                        'Logout Confirmation', () {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(SignOutRequested());
                                      if (context.canPop()) {
                                        context.pop();
                                      }
                                    }, 'Logout'),
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
        return const SizedBox();
      },
    );
  }
}
