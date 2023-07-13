import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/presentation/pages/bloc/switch_screen_cubit.dart';
import 'package:uplift/constant/constant.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthScreen>(
        builder: (context, screen) {
          return Scaffold(
            body: LoaderOverlay(
              closeOnBackButton: true,
              child: screen == AuthScreen.login
                  ? const LoginScreen()
                  : const RegisterScreen(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: primaryColor,
              selectedItemColor: whiteColor,
              unselectedItemColor: whiteColor.withOpacity(0.5),
              currentIndex: screen == AuthScreen.login ? 0 : 1,
              onTap: (index) {
                final authCubit = BlocProvider.of<AuthCubit>(context);
                if (index == 0) {
                  authCubit.switchToLogin();
                } else {
                  authCubit.switchToRegister();
                }
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Login',
                  icon: Icon(Icons.login),
                ),
                BottomNavigationBarItem(
                  label: 'Register',
                  icon: Icon(Icons.person_add),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
