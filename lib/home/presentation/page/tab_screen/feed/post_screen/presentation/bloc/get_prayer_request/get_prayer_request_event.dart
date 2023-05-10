part of 'get_prayer_request_bloc.dart';

abstract class GetPrayerRequestEvent extends Equatable {
  const GetPrayerRequestEvent();
}

class GetPostRequestList extends GetPrayerRequestEvent {
  const GetPostRequestList();

  @override
  List<Object> get props => [];
}

class RefreshPostRequestList extends GetPrayerRequestEvent {
  @override
  List<Object?> get props => [];
}

class AddReaction extends GetPrayerRequestEvent {
  final String userID, postID;

  const AddReaction(this.userID, this.postID);
  @override
  List<Object?> get props => [userID, postID];
}

class DeletePost extends GetPrayerRequestEvent {
  final String userID, postID;

  const DeletePost(this.userID, this.postID);
  @override
  List<Object?> get props => [userID, postID];
}

class CheckInternet extends GetPrayerRequestEvent {
  final String type;

  const CheckInternet(this.type);
  @override
  List<Object?> get props => [type];
}
