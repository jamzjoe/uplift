part of 'friends_suggestions_bloc_bloc.dart';

abstract class FriendsSuggestionsBlocEvent extends Equatable {
  const FriendsSuggestionsBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends FriendsSuggestionsBlocEvent {
  final String userID;

  const FetchUsersEvent(this.userID);
}

class RefreshFriendSuggestion extends FriendsSuggestionsBlocEvent {
  final String userID;

  const RefreshFriendSuggestion(this.userID);
}

class AddFriendEvent extends FriendsSuggestionsBlocEvent {
  final FriendShipModel friendShipModel;

  const AddFriendEvent(this.friendShipModel);
  @override
  List<Object> get props => [friendShipModel];
}

class SearchFriendSuggestions extends FriendsSuggestionsBlocEvent {
  final String query;

  const SearchFriendSuggestions(this.query);
  @override
  List<Object> get props => [query];
}
