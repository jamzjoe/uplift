part of 'encourage_bloc.dart';

abstract class EncourageEvent extends Equatable {
  const EncourageEvent();
}

class FetchEncourageEvent extends EncourageEvent {
  final String postID;

  const FetchEncourageEvent(this.postID);

  @override
  List<Object?> get props => [postID];
}

class RefreshEncourageEvent extends EncourageEvent {
  final String postID;

  const RefreshEncourageEvent(this.postID);

  @override
  List<Object?> get props => [postID];
}

class AddEncourageEvent extends EncourageEvent {
  final String postID, userID, comment;

  const AddEncourageEvent(this.postID, this.userID, this.comment);

  @override
  List<Object?> get props => [postID, userID, comment];
}
