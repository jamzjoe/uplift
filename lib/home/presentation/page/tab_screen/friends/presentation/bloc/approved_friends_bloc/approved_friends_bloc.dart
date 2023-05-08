import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';

import '../../../domain/repository/friends_repository.dart';

part 'approved_friends_event.dart';
part 'approved_friends_state.dart';

final FriendsRepository friendsRepository = FriendsRepository();
late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

class ApprovedFriendsBloc
    extends Bloc<ApprovedFriendsEvent, ApprovedFriendsState> {
  ApprovedFriendsBloc() : super(ApprovedFriendsInitial()) {
    on<ApprovedFriendsEvent>((event, emit) {});
    streamSubscription = FirebaseFirestore.instance
        .collection('Friendships')
        .snapshots()
        .listen((event) async {
      add(const FetchApprovedFriendRequest2());
    });

    on<FetchApprovedFriendRequest2>((event, emit) async {
      try {
        final data = await friendsRepository.fetchApprovedFriendRequest();
        emit(ApprovedFriendsSuccess2(data));
      } catch (e) {
        log(e.toString());
        emit(ApprovedFriendsError());
      }
    });

    on<SearchApprovedFriend>((event, emit) async {
      try {
        final data =
            await friendsRepository.searchApprovedFriendRequest(event.query);
        if (data.isEmpty) {
          emit(EmptySearchResult());
        } else {
          emit(ApprovedFriendsSuccess2(data));
        }
      } catch (e) {
        emit(ApprovedFriendsError());
      }
    });

    on<UnfriendEvent>((event, emit) async {
      try {
        await friendsRepository.unfriend(event.friendShipID);
      } catch (e) {
        emit(ApprovedFriendsError());
      }
    });
  }
}
