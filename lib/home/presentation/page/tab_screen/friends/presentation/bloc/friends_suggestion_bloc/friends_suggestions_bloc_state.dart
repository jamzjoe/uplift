part of 'friends_suggestions_bloc_bloc.dart';

abstract class FriendsSuggestionsBlocState extends Equatable {
  const FriendsSuggestionsBlocState();
}

class FriendsSuggestionsBlocInitial extends FriendsSuggestionsBlocState {
  @override
  List<Object> get props => [];
}

class FriendsSuggestionLoading extends FriendsSuggestionsBlocState {
  @override
  List<Object> get props => [];
}

class FriendsSuggestionLoadingSuccess extends FriendsSuggestionsBlocState {
  final List<UserMutualFriendsModel> users;

  const FriendsSuggestionLoadingSuccess(this.users);
  @override
  List<Object> get props => [users];
}

class FriendsSuggestionLoadingError extends FriendsSuggestionsBlocState {
  @override
  List<Object> get props => [];
}
