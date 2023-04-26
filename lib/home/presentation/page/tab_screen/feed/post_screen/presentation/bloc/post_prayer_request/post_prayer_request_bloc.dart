import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/utils/services/prayer_post_services.dart';

part 'post_prayer_request_event.dart';
part 'post_prayer_request_state.dart';

class PostPrayerRequestBloc
    extends Bloc<PostPrayerRequestEvent, PostPrayerRequestState> {
  PostPrayerRequestBloc() : super(PostPrayerRequestInitial()) {
    on<PostPrayerRequestActivity>((event, emit) async {
      emit(PostPrayerRequestLoading());
      try {
        await Future.delayed(const Duration(seconds: 3), () async {
          await PrayerPostService.postPrayerRequest(event.user, event.text);
        });
        emit(Posted());
        await Future.delayed(const Duration(seconds: 3), () async {
          emit(PostPrayerRequestSuccess());
        });
      } catch (e) {
        log('Error');
        emit(PostPrayerRequestError());
      }
    });
  }
}
