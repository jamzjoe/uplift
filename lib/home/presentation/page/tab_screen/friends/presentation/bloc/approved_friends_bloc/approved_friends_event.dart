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

class RefreshApprovedFriend extends ApprovedFriendsEvent {
  final String userID;
  const RefreshApprovedFriend(this.userID);

  @override
  List<Object> get props => [];
}

// class SearchApprovedFriend extends ApprovedFriendsEvent {
//   final String query;
//   const SearchApprovedFriend(this.query);
//   @override
//   List<Object> get props => [query];
// }

class UnfriendEvent extends ApprovedFriendsEvent {
  final String friendShipID;
  final List<UserApprovedMutualFriends> users;

  const UnfriendEvent(this.friendShipID, this.users);
  @override
  List<Object> get props => [friendShipID];
}
