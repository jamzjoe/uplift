import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/utils/router/router.dart';

class IntroductionRepository {
  Future googleLogin(BuildContext context) async {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(GoogleSignInRequested('', context, false));
  }

  void goToLogin(BuildContext context) {
    router.pushNamed('login');
  }

  void goToRegister(BuildContext context) {
    router.pushNamed('register');
  }
}
