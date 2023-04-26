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
      log(user.toString());
      if (user != null) {
        add(SignIn(user));
      } else {
        add(SignOut());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.signInWithGoogle();
        AuthServices.addUser(user!);
        emit(UserIsIn(user));
      } catch (e) {
        log('Error');
        emit(UserIsOut());
      }
    });

    on<SignInWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.signInWithEmailAndPassword(
            event.email, event.password);
        AuthServices.addUser(user!);
        emit(UserIsIn(user));
      } catch (e) {
        log('Error');
        emit(UserIsOut());
      }
    });

    on<RegisterWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.registerWithEmailAndPassword(
            event.email, event.password);
        AuthServices.addUser(user!);
        emit(UserIsIn(user));
      } catch (e) {
        log('Error');
        emit(UserIsOut());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      log('Sign out');
      AuthServices.signOut();
    });

    on<SignIn>((event, emit) => emit(UserIsIn(event.user)));
    on<SignOut>((event, emit) => emit(UserIsOut()));
  }
}
