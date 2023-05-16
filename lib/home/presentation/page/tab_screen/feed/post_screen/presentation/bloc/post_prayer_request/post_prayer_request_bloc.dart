import 'dart:io';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
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
        log(event.image.toString());
        await Future.delayed(const Duration(seconds: 3), () async {
          await prayerRequestRepository.postPrayerRequest(
              event.user, event.text, event.image, event.name, event.approvedFriendsList);
        });
        emit(Posted());
        await Future.delayed(const Duration(seconds: 3), () async {
          emit(PostPrayerRequestSuccess());
        });
      } catch (e) {
        emit(PostPrayerRequestError());
      }
    });
  }
}
