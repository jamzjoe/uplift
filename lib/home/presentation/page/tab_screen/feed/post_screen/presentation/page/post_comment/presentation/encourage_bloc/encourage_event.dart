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
  final TextEditingController controller;
  final BuildContext context;
  final ScrollController scrollController;

  const AddEncourageEvent(this.postID, this.comment, this.postUserModel,
      this.currentUser, this.controller, this.context, this.scrollController);

  @override
  List<Object?> get props => [postID, currentUser, comment, postUserModel];
}
