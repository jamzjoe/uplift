part of 'search_friend_bloc.dart';

abstract class SearchFriendState extends Equatable {
  const SearchFriendState();
}

class SearchFriendInitial extends SearchFriendState {
  @override
  List<Object> get props => [];
}

class SearchFriendLoading extends SearchFriendState {
  @override
  List<Object> get props => [];
}

class SearchFriendSuccess extends SearchFriendState {
  final List<UserModel> users;

  const SearchFriendSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class SearchFriendError extends SearchFriendState {
  @override
  List<Object> get props => [];
}
