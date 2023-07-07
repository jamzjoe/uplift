part of 'search_friend_bloc.dart';

abstract class SearchFriendEvent extends Equatable {
  const SearchFriendEvent();
}

class SearchUserEvent extends SearchFriendEvent {
  final String query;

  const SearchUserEvent(this.query);

  @override
  List<Object> get props => [query];
}
