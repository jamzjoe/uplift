import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_approved_mutual.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

part 'friend_request_event.dart';
part 'friend_request_state.dart';

final FriendsRepository friendsRepository = FriendsRepository();
late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> streamSubscription;

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  FriendRequestBloc() : super(FriendRequestInitial()) {
    on<FriendRequestEvent>((event, emit) {});

    startFriendRequestStream();

    on<FetchFriendRequestEvent>((event, emit) async {
      try {
        final data = await friendsRepository.fetchFriendRequest(event.userID);
        emit(FriendRequestLoadingSuccess(data!));
      } catch (e) {
        log(e.toString());
        emit(FriendRequestLoadingError());
      }
    });
  }

  void startFriendRequestStream() async {
    final userID = await AuthServices.userID();
    final query = FirebaseFirestore.instance.collection('Friendships');

    streamSubscription = query.snapshots().listen((QuerySnapshot event) {
      // Check if there are any new events added
      if (event.docChanges.isNotEmpty) {
        // Check if any new event is added (DocumentChangeType.added)
        final hasNewEvent = event.docChanges.any(
          (change) =>
              change.type == DocumentChangeType.added ||
              change.type == DocumentChangeType.modified,
        );

        if (hasNewEvent) {
          add(FetchFriendRequestEvent(userID.toString()));
        }
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
