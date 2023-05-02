part of 'friends_suggestions_bloc_bloc.dart';

abstract class FriendsSuggestionsBlocEvent extends Equatable {
  const FriendsSuggestionsBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends FriendsSuggestionsBlocEvent {}
