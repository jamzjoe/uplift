import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';
part 'friend_request_event.dart';
part 'friend_request_state.dart';

final FriendsRepository friendsRepository = FriendsRepository();
late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  FriendRequestBloc() : super(FriendRequestInitial()) {
    on<FriendRequestEvent>((event, emit) {});

    streamSubscription = FirebaseFirestore.instance
        .collection('Notifications')
        .snapshots()
        .listen((event) async {
      final userID = await AuthServices.userID();
      add(FetchFriendRequestEvent(userID.toString()));
    });

    on<FetchFriendRequestEvent>((event, emit) async {
      try {
        final data = await friendsRepository.fetchFriendRequest();
        emit(FriendRequestLoadingSuccess(data));
      } catch (e) {
        emit(FriendRequestLoadingError());
      }
    });
  }
}
