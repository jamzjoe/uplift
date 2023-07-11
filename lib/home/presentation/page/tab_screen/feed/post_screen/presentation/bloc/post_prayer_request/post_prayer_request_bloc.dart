import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../../../../../../../authentication/data/model/user_model.dart';

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
        await prayerRequestRepository
            .postPrayerRequest(event.user, event.text, event.name,
                event.followers, event.title)
            .then((value) {
          ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
              backgroundColor: primaryColor,
              content:
                  SmallText(text: 'Posted successfully', color: whiteColor)));
        });
        emit(PostPrayerRequestSuccess());
      } catch (e) {
        emit(PostPrayerRequestError());
      }
    });
  }
}
