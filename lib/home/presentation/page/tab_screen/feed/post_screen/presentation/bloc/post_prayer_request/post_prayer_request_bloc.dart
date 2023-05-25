import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';

part 'post_prayer_request_event.dart';
part 'post_prayer_request_state.dart';

final PrayerRequestRepository prayerRequestRepository =
    PrayerRequestRepository();

class PostPrayerRequestBloc
    extends Bloc<PostPrayerRequestEvent, PostPrayerRequestState> {
  PostPrayerRequestBloc() : super(PostPrayerRequestInitial()) {
    on<PostPrayerRequestActivity>((event, emit) async {
      emit(PostPrayerRequestLoading());
      try {
        await prayerRequestRepository.postPrayerRequest(event.user, event.text,
            event.image, event.name, event.approvedFriendsList, event.title);
        emit(Posted());
        emit(PostPrayerRequestSuccess());
      } catch (e) {
        emit(PostPrayerRequestError());
      }
    });
  }
}
