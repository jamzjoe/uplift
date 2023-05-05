part of 'approved_friends_bloc.dart';

abstract class ApprovedFriendsEvent extends Equatable {
  const ApprovedFriendsEvent();
}

class FetchApprovedFriendRequest extends ApprovedFriendsEvent {
  const FetchApprovedFriendRequest();

  @override
  List<Object> get props => [];
}
