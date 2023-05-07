import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/friendship_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friends_repository.dart';

part 'friends_suggestions_bloc_event.dart';
part 'friends_suggestions_bloc_state.dart';

final FriendsRepository friendSuggestionRepository = FriendsRepository();

late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

class FriendsSuggestionsBlocBloc
    extends Bloc<FriendsSuggestionsBlocEvent, FriendsSuggestionsBlocState> {
  FriendsSuggestionsBlocBloc() : super(FriendsSuggestionsBlocInitial()) {
    streamSubscription = FirebaseFirestore.instance
        .collection('Friendships')
        .snapshots()
        .listen((event) async {
      add(FetchUsersEvent());
    });

    on<FriendsSuggestionsBlocEvent>((event, emit) {});

    on<FetchUsersEvent>((event, emit) async {
      try {
        final data = await friendSuggestionRepository.fetchUsersSuggestions();
        emit(FriendsSuggestionLoadingSuccess(data));
      } on FirebaseAuthException catch (e) {
        emit(FriendsSuggestionLoadingError());
      }
    });

    on<AddFriendEvent>((event, emit) async {
      try {
        final response = await friendSuggestionRepository
            .addFriendshipRequest(event.friendShipModel);
      } catch (e) {}
    });
  }
}
