part of 'friend_request_bloc.dart';

abstract class FriendRequestEvent extends Equatable {
  const FriendRequestEvent();

  @override
  List<Object> get props => [];
}

class FetchFriendRequestEvent extends FriendRequestEvent {
  final String userID;

  const FetchFriendRequestEvent(this.userID);
  @override
  List<Object> get props => [userID];
}

class SearchFriendRequestEvent extends FriendRequestEvent {
  final String userID;

  const SearchFriendRequestEvent(this.userID);
  @override
  List<Object> get props => [userID];
}
