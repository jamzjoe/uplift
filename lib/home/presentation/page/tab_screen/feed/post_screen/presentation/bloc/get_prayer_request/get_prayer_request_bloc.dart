import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

part 'get_prayer_request_event.dart';
part 'get_prayer_request_state.dart';

final PrayerRequestRepository prayerRequestRepository =
    PrayerRequestRepository();
late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

class GetPrayerRequestBloc
    extends Bloc<GetPrayerRequestEvent, GetPrayerRequestState> {
  GetPrayerRequestBloc() : super(GetPrayerRequestInitial()) {
    streamSubscription = FirebaseFirestore.instance
        .collection('Prayers')
        .snapshots()
        .listen((event) async {
      add(const GetPostRequestList());
    });
    on<GetPrayerRequestEvent>((event, emit) {});

    on<GetPostRequestList>((event, emit) async {
      emit(LoadingPrayerRequesList());
      try {
        final data = await prayerRequestRepository.getPrayerRequestList();

        await Future.delayed(const Duration(seconds: 1), () async {
          emit(LoadingPrayerRequesListSuccess(data));
        });
      } on FirebaseException catch (e) {
        log(e.toString());
        emit(LoadingPrayerRequesListError());
      }
    });

    on<EmitLoading>((event, emit) {
      emit(LoadingPrayerRequesList());
    });
  }
}
