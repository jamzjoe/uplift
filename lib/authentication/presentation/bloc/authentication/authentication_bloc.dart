import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User?> streamSubscription;
  AuthenticationBloc(this.authRepository) : super(AuthenticationInitial()) {
    streamSubscription = authRepository.user.listen((user) {
      if (user != null) {
        add(SignIn(user));
      } else {
        add(SignOut());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      try {
        AuthServices.signInWithGoogle();
      } catch (e) {
        emit(UserIsOut());
      }
    });

    on<SignOutRequested>((event, emit) async {
      log('Sign out');
      AuthServices.signOut();
    });

    on<SignIn>((event, emit) => emit(UserIsIn(event.user)));
    on<SignOut>((event, emit) => emit(UserIsOut()));
  }
}
