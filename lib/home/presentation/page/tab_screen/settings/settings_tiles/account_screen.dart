import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/settings/settings_item.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/pop_up.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Account', color: darkColor),
      ),
      body: ListView(
        children: [
          SettingsItem(
              onTap: () => CustomDialog.showDeleteConfirmation(
                      context,
                      'Are you sure you want to delete your account?',
                      'Delete Confirmation', () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(const DeleteAccount());
                    context.pop();
                  }, 'Delete Account'),
              label: 'Delete Account',
              icon: Ionicons.trash_bin),
          SettingsItem(
              onTap: () => context.pushNamed('forgotPassword'),
              label: 'Forgot Password',
              icon: Ionicons.lock_closed),
        ],
      ),
    );
  }
}
