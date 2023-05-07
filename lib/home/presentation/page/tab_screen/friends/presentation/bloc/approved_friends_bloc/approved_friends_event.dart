part of 'approved_friends_bloc.dart';

abstract class ApprovedFriendsEvent extends Equatable {
  const ApprovedFriendsEvent();
}

class FetchApprovedFriendRequest extends ApprovedFriendsEvent {
  const FetchApprovedFriendRequest();

  @override
  List<Object> get props => [];
}

class FetchApprovedFriendRequest2 extends ApprovedFriendsEvent {
  const FetchApprovedFriendRequest2();

  @override
  List<Object> get props => [];
}

class SearchApprovedFriend extends ApprovedFriendsEvent {
  final String query;
  const SearchApprovedFriend(this.query);
  @override
  List<Object> get props => [query];
}
