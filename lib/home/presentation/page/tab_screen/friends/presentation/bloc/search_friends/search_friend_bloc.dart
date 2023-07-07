import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/domain/repository/search_repository.dart';

part 'search_friend_event.dart';
part 'search_friend_state.dart';

final SearchFriendRepository searchFriendRepository = SearchFriendRepository();

class SearchFriendBloc extends Bloc<SearchFriendEvent, SearchFriendState> {
  SearchFriendBloc() : super(SearchFriendInitial()) {
    on<SearchFriendEvent>((event, emit) {});
    on<SearchUserEvent>((event, emit) async {
      try {
        final users = await searchFriendRepository.searchUser(event.query);
        emit(SearchFriendSuccess(users));
      } catch (e) {
        log(e.toString());
        emit(SearchFriendError());
      }
    });
  }
}
