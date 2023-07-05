import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_approved_mutual.dart';

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

    on<FetchApprovedFriendRequest>((event, emit) async {
      emit(ApprovedFriendsLoading());
      try {
        final data = await friendsRepository
            .fetchApprovedFriendRequestWithMutual(event.userID);
        emit(ApprovedFriendsSuccess2(data));
      } catch (e) {
        log(e.toString());
        emit(ApprovedFriendsError());
      }
    });

    on<RefreshApprovedFriend>((event, emit) async {
      try {
        final data = await friendsRepository
            .fetchApprovedFriendRequestWithMutual(event.userID);
        emit(ApprovedFriendsSuccess2(data));
      } catch (e) {
        log(e.toString());
        emit(ApprovedFriendsError());
      }
    });

    on<UnfriendEvent>((event, emit) async {
      try {
        await friendsRepository.unfriend(event.friendShipID);
        emit(ApprovedFriendsSuccess2(event.users
            .where((element) =>
                element.userFriendshipModel.friendshipID.friendshipId !=
                event.friendShipID)
            .toList()));
      } catch (e) {
        emit(ApprovedFriendsError());
      }
    });
  }
}
