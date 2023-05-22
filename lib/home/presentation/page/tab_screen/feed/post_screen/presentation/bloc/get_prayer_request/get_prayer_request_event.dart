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
  final UserModel userModel;
  final UserModel currentUser;
  const AddReaction(this.userID, this.postID, this.userModel, this.currentUser);
  @override
  List<Object?> get props => [userID, postID];
}

class DeletePost extends GetPrayerRequestEvent {
  final String userID, postID;

  const DeletePost(this.userID, this.postID);
  @override
  List<Object?> get props => [userID, postID];
}

class GetPrayerRequestByPopularity extends GetPrayerRequestEvent {
  @override
  List<Object?> get props => [];
}

class SearchPrayerRequest extends GetPrayerRequestEvent {
  final String query;

  const SearchPrayerRequest(this.query);
  @override
  List<Object?> get props => [query];
}

class CheckInternet extends GetPrayerRequestEvent {
  final String type;

  const CheckInternet(this.type);
  @override
  List<Object?> get props => [type];
}
