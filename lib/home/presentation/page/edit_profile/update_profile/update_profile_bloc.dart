import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/authentication/domain/repository/auth_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

final AuthRepository _authRepository = AuthRepository();

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<UpdateProfileEvent>((event, emit) {});

    on<UpdateProfileInformationEvent>((event, emit) async {
      emit(UpdateProfileLoading());

      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(event.userID)
            .update({
              'phone_number': event.contactNo,
              "bio": event.bio,
              "display_name": event.displayName,
              "email_address": event.emailAddress,
              "photo_url": event.photoURL
            })
            .then((value) => log('Profile updated successfully!'))
            .catchError(
                (error) => log('Profile number updating error: $error'));

        UserModel? userModel =
            await PrayerRequestRepository().getUserRecord(event.userID);
        final User currentUser = FirebaseAuth.instance.currentUser!;
        emit(UpdateProfileSuccess(UserJoinedModel(userModel!, currentUser)));
      } catch (e) {
        log(e.toString());
        emit(UpdateProfileError());
      }
    });

    on<SetLoadingEvent>((event, emit) {
      emit(UpdateProfileLoading());
    });
  }
}
