import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/explore/domain/explore_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

part 'explore_prayer_request_event.dart';
part 'explore_prayer_request_state.dart';

final ExploreRepository exploreRepository = ExploreRepository();
final PrayerRequestRepository prayerRequestRepository =
    PrayerRequestRepository();
late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;
final String userID = FirebaseAuth.instance.currentUser!.uid;

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(GetPrayerRequestInitial()) {
    // streamSubscription = FirebaseFirestore.instance
    //     .collection('Prayers')
    //     .snapshots()
    //     .listen((event) async {
    //   add(GetExplorePrayerRequestList(userID));
    // });
    on<ExploreEvent>((event, emit) {});

    on<GetExplorePrayerRequestList>((event, emit) async {
      try {
        final data = await exploreRepository.getAllPrayerRequestList(
            limit: event.limit, userID: event.userID);

        emit(LoadingPrayerRequesListSuccess(data));
      } catch (e) {
        emit(LoadingPrayerRequesListError());
      }
    });

    on<SearchPrayerRequest>((event, emit) async {
      try {
        final data = event.posts
            .where((post) =>
                post.userModel.displayName!
                    .toLowerCase()
                    .contains(event.query.toLowerCase()) ||
                post.prayerRequestPostModel.text!
                    .toLowerCase()
                    .contains(event.query.toLowerCase()))
            .toList();
        emit(LoadingPrayerRequesListSuccess(data));
      } catch (e) {
        emit(LoadingPrayerRequesListError());
      }
    });

    // on<GetPrayerRequestByPopularity>((event, emit) async {
    //   emit(LoadingPrayerRequesList());
    //   try {
    //     final data =
    //         await prayerRequestRepository.getPrayerRequestListByReactions();
    //     emit(LoadingPrayerRequesListSuccess(data));
    //   } on FirebaseException {
    //     emit(LoadingPrayerRequesListError());
    //   }
    // });

    on<RefreshPostRequestList>((event, emit) async {
      emit(LoadingPrayerRequesList());
      try {
        final data = await exploreRepository.getAllPrayerRequestList(
            userID: event.userID);
        emit(LoadingPrayerRequesListSuccess(data));
      } on FirebaseException {
        emit(LoadingPrayerRequesListError());
      }
    });

    on<AddReaction>((event, emit) async {
      log('Running');
      try {
        await prayerRequestRepository.addReaction(
            event.postID, event.userID, event.userModel, event.currentUser);
      } catch (e) {
        log(e.toString());
      }
    });

    on<DeletePost>((event, emit) async {
      try {
        await prayerRequestRepository.deletePost(event.postID, event.userID);
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
