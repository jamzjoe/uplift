part of 'same_intentions_suggestion_bloc.dart';

abstract class SameIntentionsSuggestionState extends Equatable {
  const SameIntentionsSuggestionState();
}

class SameIntentionsSuggestionInitial extends SameIntentionsSuggestionState {
  @override
  List<Object> get props => [];
}

class LoadingSameIntentionSuccess extends SameIntentionsSuggestionState {
  final List<IntentionsAndUserModel> intentionsAndUser;

  const LoadingSameIntentionSuccess(this.intentionsAndUser);
  @override
  List<Object> get props => [intentionsAndUser];
}

class LoadingSameIntention extends SameIntentionsSuggestionState {
  const LoadingSameIntention();
  @override
  List<Object> get props => [];
}

class LoadingSameIntentionError extends SameIntentionsSuggestionState {
  const LoadingSameIntentionError();
  @override
  List<Object> get props => [];
}
