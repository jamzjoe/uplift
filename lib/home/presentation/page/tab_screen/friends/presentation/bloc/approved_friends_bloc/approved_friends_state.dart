part of 'approved_friends_bloc.dart';

abstract class ApprovedFriendsState extends Equatable {
  const ApprovedFriendsState();
}

class ApprovedFriendsInitial extends ApprovedFriendsState {
  @override
  List<Object> get props => [];
}

class ApprovedFriendsLoading extends ApprovedFriendsState {
  @override
  List<Object> get props => [];
}

class ApprovedFriendsSuccess extends ApprovedFriendsState {
  final List<UserModel> approvedFriendsList;

  const ApprovedFriendsSuccess(this.approvedFriendsList);

  @override
  List<Object> get props => [approvedFriendsList];
}

class ApprovedFriendsSuccess2 extends ApprovedFriendsState {
  final List<UserModel> approvedFriendList;

  const ApprovedFriendsSuccess2(this.approvedFriendList);
  @override
  List<Object> get props => [approvedFriendList];
}

class ApprovedFriendsError extends ApprovedFriendsState {
  @override
  List<Object> get props => [];
}
