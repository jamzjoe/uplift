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
  final String postID, comment;
  final UserModel currentUser;
  final UserModel postUserModel;

  const AddEncourageEvent(
      this.postID, this.comment, this.postUserModel, this.currentUser);

  @override
  List<Object?> get props => [postID, currentUser, comment, postUserModel];
}
