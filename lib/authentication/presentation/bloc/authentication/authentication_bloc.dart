import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
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
  AuthenticationBloc(this.authRepository) : super(AuthenticationInitial()) {
    streamSubscription = authRepository.user.listen((user) async {
      final UserJoinedModel userJoinedModel;
      if (user != null) {
        UserModel userModel =
            await PrayerRequestRepository().getUserRecord(user.uid);
        userJoinedModel = UserJoinedModel(userModel, user);
        add(SignIn(userJoinedModel));
      } else {
        add(SignOut());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        final UserJoinedModel user = await AuthServices.signInWithGoogle();
        AuthServices.addUser(user.user, event.bio);
        emit(UserIsIn(user));
      } catch (e) {
        log('Error');
        emit(UserIsOut(e.toString()));
      }
    });

    on<SignInWithEmailAndPassword>((event, emit) async {
      emit(Loading());
      try {
        final UserJoinedModel user =
            await AuthServices.signInWithEmailAndPassword(
                event.email, event.password);
        log(user.toString());
        AuthServices.addUserFromEmailAndPassword(user.user, event.bio);
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
        final UserJoinedModel user =
            await AuthServices.registerWithEmailAndPassword(
                event.email, event.password);
        log(user.toString());
        AuthServices.addUserFromEmailAndPassword(user.user, event.bio);
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
