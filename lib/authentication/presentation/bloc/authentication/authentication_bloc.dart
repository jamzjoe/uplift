import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
        try {
          final token = await FirebaseMessaging.instance.getToken();
          final userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .update({"device_token": token});

            final userModel =
                await PrayerRequestRepository().getUserRecord(user.uid);

            add(SignIn(UserJoinedModel(userModel!, user)));
          } else {
            add(SignOut());
          }
        } catch (e) {
          add(SignOut());
        }
      } else {
        add(SignOut());
      }
    });

    on<SignIn>((event, emit) async {
      emit(UserIsIn(event.userJoinedModel));
    });

    on<GoogleSignInRequested>((event, emit) async {
      event.context.loaderOverlay.show();
      try {
        final User? user = await AuthServices.signInWithGoogle();

        if (user == null) {
          // Google sign-in was canceled
          event.context.loaderOverlay.hide();
          return; // Exit the function without further processing
        }

        await AuthServices.addUser(user, user.displayName, 'google_sign_in');
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());

        emit(UserIsIn(UserJoinedModel(userModel!, user)));
        if (event.fromLogin) {
          // ignore: use_build_context_synchronously
          event.context.pop();
        }

        event.context.loaderOverlay.hide();
      } on PlatformException catch (e) {
        event.context.loaderOverlay.hide();
        if (e.code == 'network_error') {
          emit(const UserIsOut(
              'No internet connection', 'Authentication Error'));
          CustomDialog.showErrorDialog(event.context, 'No internet connection',
              'Authentication Error', 'Confirm');
        } else {
          emit(UserIsOut(e.message!, 'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context, e.message!, 'Authentication Error', 'Confirm');
        }
      } catch (e) {
        event.context.loaderOverlay.hide();
      }
    });

    on<SignInWithEmailAndPassword>((event, emit) async {
      event.context.loaderOverlay.show();
      final findUser =
          await PrayerRequestRepository().findUserByEmail(event.email.text);
      if (findUser!.provider == 'google_sign_in') {
        event.context.loaderOverlay.hide();
        if (event.context.mounted) {
          // ignore: use_build_context_synchronously
          CustomDialog.showErrorDialog(
              event.context,
              "Your current sign-in method is Google. Please continue signing in using the Google Sign-In option",
              'Authentication Error',
              'Understood');
        }
        emit(const UserIsOut(
            "Your current sign-in method is Google. Please continue signing in using the Google Sign-In option",
            'Authentication Error'));
      } else {
        try {
          emit(Loading());

          final User? user = await AuthServices.signInWithEmailAndPassword(
            event.email.text,
            event.password.text,
          );
          if (user != null) {
            final userModel = await PrayerRequestRepository()
                .getUserRecord(await AuthServices.userID());
            final token = await FirebaseMessaging.instance.getToken();

            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .update({"device_token": token}).then(
                    (value) => event.context.pop());

            if (userModel != null) {
              emit(UserIsIn(UserJoinedModel(userModel, user)));
              event.email.clear();
              event.password.clear();
            } else {
              emit(const UserIsOut(
                  "Failed to get user record.", 'Authentication Error'));
            }
          } else {
            emit(const UserIsOut("Failed to sign in.", 'Authentication Error'));
          }
        } on FirebaseAuthException catch (e) {
          log(e.code);
          if (e.code == 'NOT_FOUND') {
            emit(const UserIsOut(
                "No user found for that credentials.", 'Authentication Error'));
            // ignore: use_build_context_synchronously
            CustomDialog.showErrorDialog(
                event.context,
                'No user found for that email.',
                'Authentication Error',
                'Confirm');
          } else if (e.code == 'wrong-password') {
            // ignore: use_build_context_synchronously
            CustomDialog.showErrorDialog(
                event.context, e.message!, 'Authentication Error', 'Confirm');
            emit(const UserIsOut("Wrong password provided for that user.",
                'Authentication Error'));
          } else {
            UserIsOut(e.toString(), 'Error');
            CustomDialog.showErrorDialog(
                event.context, e.message!, 'Authentication Error', 'Confirm');
          }
        } catch (e) {
          event.context.loaderOverlay.hide();
          CustomDialog.showErrorDialog(
              event.context, e.toString(), 'Authentication Error', 'Confirm');
          UserIsOut(e.toString(), 'Error');
        } finally {
          event.context.loaderOverlay.hide();
        }
      }
    });

    on<RegisterWithEmailAndPassword>((event, emit) async {
      event.context.loaderOverlay.show();
      try {
        emit(Loading());
        final User? user = await AuthServices().registerWithEmailAndPassword(
            event.email.text, event.password.text);
        AuthServices.addUserFromEmailAndPassword(
            user!, event.bio, event.userName.text);

        final userModel = await PrayerRequestRepository()
            .getUserRecord(user.uid)
            .then((value) {
          event.context.pop();
          event.context.pop();
          event.context.loaderOverlay.hide();
        });

        emit(UserIsIn(UserJoinedModel(userModel!, user)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(const UserIsOut(
              "The password provided is too weak.", 'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context,
              "The password provided is too weak.",
              'Authentication Error',
              'Confirm');
        } else if (e.code == 'email-already-in-use') {
          emit(const UserIsOut('The account already exists for that email.',
              'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context,
              'The account already exists for that email.',
              'Authentication Error',
              'Confirm');
        } else if (e.code == 'network-request-failed') {
          emit(const UserIsOut('No internet connection or unreachable host.',
              'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context,
              'No internet connection or unreachable host.',
              'Authentication Error',
              'Confirm');
        } else {
          emit(UserIsOut(e.message!, 'Authentication Error'));
          CustomDialog.showErrorDialog(
              event.context, e.toString(), 'Authentication Error', 'Confirm');
        }
      } finally {
        event.context.loaderOverlay.hide();
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      emit(const UserIsOut(
          'You are redirected to login screen.', 'Logout Success'));
      log('Sign out');
      AuthServices.signOut();
    });

    on<SignOut>((event, emit) => emit(const UserIsOut(
        'You are redirected to login screen.', 'Logout Success')));

    on<UpdateBio>((event, emit) async {
      await AuthRepository.updateBio(event.bio, event.userID);
      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser!;
      log(user.displayName!);
    });

    on<DeleteAccount>((event, emit) async {
      final User user = FirebaseAuth.instance.currentUser!;
      try {
        await user.delete();
        await GoogleSignIn().disconnect();
        await AuthServices().deleteUser(user.uid);
        emit(const UserIsOut('Deleted', ''));
      } catch (e) {
        final userModel = await PrayerRequestRepository()
            .getUserRecord(await AuthServices.userID());
        emit(UserIsIn(UserJoinedModel(userModel!, user)));
      }
    });

    on<UpdateProfile>((event, emit) async {
      event.context.loaderOverlay
          .show(); // Show the loader overlay before the asynchronous update
      await AuthRepository.updateProfile(
        event.displayName,
        event.emailAddress,
        event.contactNo,
        event.bio,
        event.userID,
      ).then((value) {
        event.context.loaderOverlay.show();
      });
    });
  }
}
