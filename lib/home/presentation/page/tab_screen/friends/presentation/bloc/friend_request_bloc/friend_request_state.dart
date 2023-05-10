part of 'friend_request_bloc.dart';

abstract class FriendRequestState extends Equatable {
  const FriendRequestState();

  @override
  List<Object> get props => [];
}

class FriendRequestInitial extends FriendRequestState {}

class FriendRequestLoading extends FriendRequestState {}

class FriendRequestLoadingSuccess extends FriendRequestState {
  final List<UserFriendshipModel> users;

  const FriendRequestLoadingSuccess(this.users);
  @override
  List<Object> get props => [users];
}

class FriendRequestLoadingError extends FriendRequestState {}
