part of 'get_prayer_request_bloc.dart';

abstract class GetPrayerRequestEvent extends Equatable {
  const GetPrayerRequestEvent();
}

class GetPostRequestList extends GetPrayerRequestEvent {
  final int? limit;
  final String userID;
  final BuildContext? context;
  const GetPostRequestList(this.userID, {this.limit, this.context});

  @override
  List<Object> get props => [];
}

class RefreshPostRequestList extends GetPrayerRequestEvent {
  final String userID;
  const RefreshPostRequestList(this.userID);
  @override
  List<Object?> get props => [];
}

class AddReaction extends GetPrayerRequestEvent {
  final String userID, postID;
  final UserModel userModel;
  final UserModel currentUser;
  final PostModel postModel;
  const AddReaction(this.userID, this.postID, this.userModel, this.currentUser,
      this.postModel);
  @override
  List<Object?> get props => [userID, postID, currentUser, postModel];
}

class DeletePost extends GetPrayerRequestEvent {
  final String userID, postID;
  final List<PostModel> posts;
  final BuildContext context;
  const DeletePost(this.userID, this.postID, this.posts, this.context);
  @override
  List<Object?> get props => [userID, postID];
}

class UpdatePrivacy extends GetPrayerRequestEvent {
  final List<PostModel> posts;
  final String postID;
  final BuildContext context;
  const UpdatePrivacy(this.posts, this.postID, this.context);

  @override
  List<Object?> get props => [];
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
