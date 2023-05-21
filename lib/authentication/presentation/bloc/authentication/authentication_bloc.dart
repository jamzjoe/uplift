import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/pop_up.dart';

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
      try {
        final User? user =
            await AuthServices.signInWithGoogle().then((value) async {
          if (event.fromLogin) {
            event.context.pop();
          }
          return null;
        });

        await AuthServices.addUser(
            user!, "", user.displayName, 'google_sign_in');
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
      event.context.loaderOverlay.show();
      try {
        final User? user = await AuthServices.signInWithEmailAndPassword(
                event.email.text, event.password.text)
            .then((value) async {
          event.context.loaderOverlay.hide();
          event.context.pop();
          event.email.clear();
          event.password.clear();
          return null;
        });
        log(user.toString());
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        await AuthServices.addUserFromEmailAndPassword(
          user!,
          userModel.bio!,
          userModel.displayName,
        );

        emit(UserIsIn(UserJoinedModel(userModel, user)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          event.context.loaderOverlay.hide();
          CustomDialog.showErrorDialog(
              event.context, e.message!, 'Authentication Error', 'Confirm');
          emit(const UserIsOut(
              "No user found for that email.", 'Authentication Error'));
        } else if (e.code == 'wrong-password') {
          event.context.loaderOverlay.hide();
          CustomDialog.showErrorDialog(
              event.context, e.message!, 'Authentication Error', 'Confirm');
          emit(const UserIsOut("Wrong password provided for that user.",
              'Authentication Error'));
        } else {
          event.context.loaderOverlay.hide();
          CustomDialog.showErrorDialog(
              event.context, e.message!, "Authentication Error", 'Confirm');
        }
      } catch (e) {
        event.context.loaderOverlay.hide();
        CustomDialog.showErrorDialog(event.context, 'Something went wrong!',
            'Authentication Error', 'Confirm');
      }
    });

    on<RegisterWithEmailAndPassword>((event, emit) async {
      event.context.loaderOverlay.show();
      try {
        final User? user = await AuthServices.registerWithEmailAndPassword(
            event.email.text, event.password.text);

        AuthServices.addUserFromEmailAndPassword(
                user!, event.bio, event.userName.text)
            .then((value) async {
          event.context.pop();
          event.context.pop();
          event.email.clear();
          event.password.clear();
          event.userName.clear();

          event.context.loaderOverlay.hide();
        });
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());

        emit(UserIsIn(UserJoinedModel(userModel, user)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          event.context.loaderOverlay.hide();
          emit(const UserIsOut(
              "The password provided is too weak.", 'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context,
              'The password provided is too weak',
              'Authentication Error',
              'Confirm');
        } else if (e.code == 'email-already-in-use') {
          event.context.loaderOverlay.hide();
          emit(const UserIsOut('The account already exists for that email.',
              'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context,
              'The account already exists for that email.',
              'Authentication Error',
              'Confirm');
        } else {
          event.context.loaderOverlay.hide();
          CustomDialog.showErrorDialog(
              event.context, e.message!, "Authentication Error", 'Confirm');
        }
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      emit(const UserIsOut(
          'You are redirected to login screen.', 'Logout Success'));
      AuthServices.signOut();
    });

    on<SignIn>((event, emit) async {
      emit(UserIsIn(event.userJoinedModel));
    });
    on<SignOut>((event, emit) => emit(const UserIsOut(
        'You are redirected to login screen.', 'Logout Success')));

    on<UpdateBio>((event, emit) async {
      try {
        await AuthRepository.updateBio(event.bio, event.userID);
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.currentUser!.reload();
        final user = auth.currentUser!;
        log(user.displayName!);
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

    on<UpdateProfile>((event, emit) async {
      event.context.loaderOverlay.show();
      try {
        await AuthRepository.updateProfile(event.displayName,
                event.emailAddress, event.contactNo, event.bio, event.userID)
            .then((value) {
          CustomDialog.showCustomSnackBar(
              event.context, 'Changes updated successfully!');

          event.context.loaderOverlay.hide();
        });
      } catch (e) {
        log(e.toString());
        emit(const UserIsOut('Update failed', 'Error'));
        event.context.loaderOverlay.hide();
      }
    });
  }
}
