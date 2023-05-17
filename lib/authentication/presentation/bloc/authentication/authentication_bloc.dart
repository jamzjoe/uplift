import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

final AuthServices authServices = AuthServices();

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User?> streamSubscription;
  AuthenticationBloc(this.authRepository) : super(Loading()) {
    streamSubscription = authRepository.user.listen((user) async {
      if (user != null) {
        log('From Stream');
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        add(SignIn(UserJoinedModel(userModel, user)));
      } else {
        add(SignOut());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      log('From event');
      try {
        final User? user = await AuthServices.signInWithGoogle();
        await AuthServices.addUser(user!, event.bio, "");
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        emit(UserIsIn(UserJoinedModel(userModel, user)));
      } on PlatformException catch (e) {
        log(e.code);
        if (e.code == 'network_error') {
          emit(const UserIsOut(
              'No internet connection', 'Authentication Error'));
        }
      }
    });

    on<SignInWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.signInWithEmailAndPassword(
            event.email, event.password);
        log(user.toString());
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());

        emit(UserIsIn(UserJoinedModel(userModel, user!)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(const UserIsOut(
              "No user found for that email.", 'Authentication Error'));
        } else if (e.code == 'wrong-password') {
          emit(const UserIsOut("Wrong password provided for that user.",
              'Authentication Error'));
        }
      }
    });

    on<RegisterWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final User? user = await AuthServices.registerWithEmailAndPassword(
            event.email, event.password);
        log(user.toString());
        log(event.userName);
        AuthServices.addUserFromEmailAndPassword(
            user!, event.bio, event.userName);
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        emit(UserIsIn(UserJoinedModel(userModel, user)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(const UserIsOut(
              "The password provided is too weak.", 'Authentication Error'));
        } else if (e.code == 'email-already-in-use') {
          emit(const UserIsOut('The account already exists for that email.',
              'Authentication Error'));
        }
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      emit(const UserIsOut(
          'You are redirected to login screen.', 'Logout Success'));
      log('Sign out');
      AuthServices.signOut();
    });

    on<SignIn>((event, emit) async {
      log('From sign in');
      emit(Loading());
      emit(UserIsIn(event.userJoinedModel));
    });
    on<SignOut>((event, emit) => emit(const UserIsOut(
        'You are redirected to login screen.', 'Logout Success')));

    on<UpdateBio>((event, emit) async {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        await AuthRepository.updateBio(event.bio, event.userID);
        emit(UserIsIn(UserJoinedModel(userModel, user!)));
      } catch (e) {
        emit(UserIsOut(e.toString(), ''));
      }
    });

    on<DeleteAccount>((event, emit) async {
      final User user = FirebaseAuth.instance.currentUser!;
      try {
        await user.delete();
        await GoogleSignIn().disconnect();
        await AuthServices().deleteUser(event.user.uid);
        emit(const UserIsOut('Deleted', ''));
      } catch (e) {
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        emit(UserIsIn(UserJoinedModel(userModel, event.user)));
      }
    });
  }
}
