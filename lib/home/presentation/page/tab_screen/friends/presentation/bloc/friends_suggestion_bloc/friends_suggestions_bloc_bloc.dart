import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/friend_suggestion_repository.dart';

part 'friends_suggestions_bloc_event.dart';
part 'friends_suggestions_bloc_state.dart';

final FriendSuggestionRepository friendSuggestionRepository =
    FriendSuggestionRepository();

late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

class FriendsSuggestionsBlocBloc
    extends Bloc<FriendsSuggestionsBlocEvent, FriendsSuggestionsBlocState> {
  FriendsSuggestionsBlocBloc() : super(FriendsSuggestionsBlocInitial()) {
    streamSubscription = FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .listen((event) async {
      add(FetchUsersEvent());
    });

    on<FriendsSuggestionsBlocEvent>((event, emit) {});

    on<FetchUsersEvent>((event, emit) async {
      emit(FriendsSuggestionLoading());
      try {
        final data = await friendSuggestionRepository.fetchUsers();
        emit(FriendsSuggestionLoadingSuccess(data));
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        emit(FriendsSuggestionLoadingError());
      }
    });
  }
}
