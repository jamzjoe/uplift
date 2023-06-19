import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/widgets/small_text.dart';

part 'get_prayer_request_event.dart';
part 'get_prayer_request_state.dart';

final PrayerRequestRepository prayerRequestRepository =
    PrayerRequestRepository();
final String userID = FirebaseAuth.instance.currentUser!.uid;

class GetPrayerRequestBloc
    extends Bloc<GetPrayerRequestEvent, GetPrayerRequestState> {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      streamSubscription;

  GetPrayerRequestBloc() : super(GetPrayerRequestInitial()) {
    streamSubscription = FirebaseFirestore.instance
        .collection('Prayers')
        .snapshots()
        .listen((QuerySnapshot event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          // This code will be executed only for new documents added

          // Perform operations on the new document
          add(GetPostRequestList(userID));
        }
      }
    });

    on<GetPostRequestList>(_handleGetPostRequestList);

    on<SearchPrayerRequest>(_handleSearchPrayerRequest);

    on<GetPrayerRequestByPopularity>(_handleGetPrayerRequestByPopularity);

    on<RefreshPostRequestList>(_handleRefreshPostRequestList);

    on<AddReaction>(_handleAddReaction);

    on<DeletePost>(_handleDeletePost);

    on<UpdatePrivacy>(_handleUpdatePrivacy);
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  Future<void> _handleGetPostRequestList(
    GetPostRequestList event,
    Emitter<GetPrayerRequestState> emit,
  ) async {
    try {
      List<PostModel> data = await prayerRequestRepository.getPrayerRequestList(
        limit: event.limit ?? 10,
        userID: event.userID,
      );
      final int prayerCount = data
          .where((prayer) => prayer.prayerRequestPostModel.userId == userID)
          .toList()
          .length;
      emit(LoadingPrayerRequesListSuccess(data, length: prayerCount));
    } catch (_) {
      emit(LoadingPrayerRequesListError());
    }
  }

  Future<void> _handleSearchPrayerRequest(
    SearchPrayerRequest event,
    Emitter<GetPrayerRequestState> emit,
  ) async {
    emit(LoadingPrayerRequesList());
    try {
      final data =
          await prayerRequestRepository.searchPrayerRequest(event.query);
      emit(LoadingPrayerRequesListSuccess(data));
    } catch (e) {
      log(e.toString());
      emit(LoadingPrayerRequesListError());
    }
  }

  Future<void> _handleGetPrayerRequestByPopularity(
    GetPrayerRequestByPopularity event,
    Emitter<GetPrayerRequestState> emit,
  ) async {
    emit(LoadingPrayerRequesList());
    try {
      final data =
          await prayerRequestRepository.getPrayerRequestListByReactions();
      emit(LoadingPrayerRequesListSuccess(data));
    } on FirebaseException {
      emit(LoadingPrayerRequesListError());
    }
  }

  Future<void> _handleRefreshPostRequestList(
    RefreshPostRequestList event,
    Emitter<GetPrayerRequestState> emit,
  ) async {
    try {
      final data = await prayerRequestRepository.getPrayerRequestList(
        userID: event.userID,
      );
      final int prayerCount = data
          .where((prayer) => prayer.prayerRequestPostModel.userId == userID)
          .toList()
          .length;

      emit(LoadingPrayerRequesListSuccess(data, length: prayerCount));
    } on FirebaseException {
      emit(LoadingPrayerRequesListError());
    }
  }

  Future<void> _handleAddReaction(
      AddReaction event, Emitter<GetPrayerRequestState> emit) async {
    log('Running');
    try {
      await prayerRequestRepository.addReaction(
        event.postID,
        event.userID,
        event.userModel,
        event.currentUser,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _handleDeletePost(
      DeletePost event, Emitter<GetPrayerRequestState> emit) async {
    try {
      List<PostModel> data = event.posts
          .where((element) =>
              element.prayerRequestPostModel.postId! != event.postID)
          .toList();

      emit(LoadingPrayerRequesListSuccess(data));

      // Call the prayerRequestRepository's deletePost method to delete the post from the backend
      await prayerRequestRepository.deletePost(event.postID, event.userID);

      // Create a copy of the posts list with the specified postID removed
      List<PostModel> updatedPosts = List<PostModel>.from(event.posts)
          .where((element) =>
              element.prayerRequestPostModel.postId! != event.postID)
          .toList();

      emit(LoadingPrayerRequesListSuccess(updatedPosts));

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(content: SmallText(text: 'Deleted', color: whiteColor)),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _handleUpdatePrivacy(
      UpdatePrivacy event, Emitter<GetPrayerRequestState> emit) async {
    try {
      add(RefreshPostRequestList(userID));
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
            content: SmallText(text: 'Privacy updated', color: whiteColor)),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
