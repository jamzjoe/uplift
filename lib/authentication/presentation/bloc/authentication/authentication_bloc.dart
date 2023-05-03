import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

final AuthServices authServices = AuthServices();

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
      emit(Loading());
      try {
        final User? user = await AuthServices.signInWithGoogle();
        authServices.addUser(user!, event.bio);
        emit(UserIsIn(user));
      } catch (e) {
        log('Error');
        emit(UserIsOut(e.toString()));
      }
    });

    on<SignInWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.signInWithEmailAndPassword(
            event.email, event.password);
        authServices.addUser(user!, event.bio);
        emit(UserIsIn(user));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(const UserIsOut("No user found for that email."));
        } else if (e.code == 'wrong-password') {
          emit(const UserIsOut("Wrong password provided for that user."));
        }
      }
    });

    on<RegisterWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.registerWithEmailAndPassword(
            event.email, event.password);
        authServices.addUser(user!, event.bio);
        emit(UserIsIn(user));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(const UserIsOut("The password provided is too weak."));
        } else if (e.code == 'email-already-in-use') {
          emit(const UserIsOut('The account already exists for that email.'));
        }
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      log('Sign out');
      AuthServices.signOut();
    });

    on<SignIn>((event, emit) => emit(UserIsIn(event.user)));
    on<SignOut>((event, emit) => emit(const UserIsOut("")));
  }
}
