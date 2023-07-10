import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_item.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';

import '../../../../../../authentication/data/model/user_model.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Account', color: darkColor),
      ),
      body: ListView(
        children: [
          SettingsItem(
              onTap: () => CustomDialog.showDeleteAccountConfirmation(
                  context,
                  'Are you sure you want to delete your account?',
                  'Delete Confirmation',
                  'Delete Account'),
              label: 'Delete Account',
              icon: Ionicons.trash_bin),
          SettingsItem(
              onTap: () => CustomDialog.showResetConfirmation(
                  context,
                  'Are you sure you want to reset your password?',
                  'Reset password',
                  () => context.pushNamed('forgotPassword', extra: currentUser),
                  'Confirm'),
              label: 'Reset Password',
              icon: Ionicons.lock_closed),
        ],
      ),
    );
  }
}
