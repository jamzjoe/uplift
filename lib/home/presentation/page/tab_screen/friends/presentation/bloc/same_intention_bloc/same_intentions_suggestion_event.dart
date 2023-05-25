part of 'same_intentions_suggestion_bloc.dart';

abstract class SameIntentionsSuggestionEvent extends Equatable {
  const SameIntentionsSuggestionEvent();
}

class FetchSameIntentionEvent extends SameIntentionsSuggestionEvent {
  final String userID;

  const FetchSameIntentionEvent(this.userID);

  @override
  List<Object?> get props => [userID];
}
