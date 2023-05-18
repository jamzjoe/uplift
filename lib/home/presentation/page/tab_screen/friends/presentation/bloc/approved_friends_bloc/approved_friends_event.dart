part of 'approved_friends_bloc.dart';

abstract class ApprovedFriendsEvent extends Equatable {
  const ApprovedFriendsEvent();
}

class FetchApprovedFriendRequest extends ApprovedFriendsEvent {
  final String userID;
  const FetchApprovedFriendRequest(this.userID);

  @override
  List<Object> get props => [];
}

class SearchApprovedFriend extends ApprovedFriendsEvent {
  final String query;
  const SearchApprovedFriend(this.query);
  @override
  List<Object> get props => [query];
}

class UnfriendEvent extends ApprovedFriendsEvent {
  final String friendShipID;

  const UnfriendEvent(this.friendShipID);
  @override
  List<Object> get props => [friendShipID];
}
