import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/home.dart';
import 'package:uplift/introduction/introduction_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        log(state.toString());
        if (state is UserIsIn) {
          return HomeScreen(user: state.user);
        } else if (state is UserIsOut) {
          return const IntroductionScreen();
        } else {
          return Container();
        }
      },
    );
  }
}
