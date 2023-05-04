import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';

import '../../../data/model/friendship_model.dart';

part 'friend_request_event.dart';
part 'friend_request_state.dart';

final FriendsRepository friendsRepository = FriendsRepository();

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  FriendRequestBloc() : super(FriendRequestInitial()) {
    on<FriendRequestEvent>((event, emit) {});

    on<FetchFriendRequestEvent>((event, emit) async {
      emit(FriendRequestLoading());
      try {
        final data = await friendsRepository.getFriendRequest(event.userID);
        emit(FriendRequestLoadingSuccess(data));
      } on FirebaseFirestore catch (e) {
        log(e.toString());
        emit(FriendRequestLoadingError());
      }
    });
  }
}
