import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';

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
      add(const FetchApprovedFriendRequest());
    });

    on<FetchApprovedFriendRequest>((event, emit) async {
      try {
        final data = await friendsRepository.getApprovedFriendRequest();
        emit(ApprovedFriendsSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(ApprovedFriendsError());
      }
    });
  }
}
