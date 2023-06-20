part of 'explore_get_prayer_request_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
}

class GetExplorePrayerRequestList extends ExploreEvent {
  final int? limit;
  final String userID;
  const GetExplorePrayerRequestList(this.userID, {this.limit});

  @override
  List<Object> get props => [limit ?? ''];
}

class RefreshPostRequestList extends ExploreEvent {
  const RefreshPostRequestList(this.userID);

  final String userID;
  @override
  List<Object?> get props => [];
}

class AddReaction extends ExploreEvent {
  final String userID, postID;
  final UserModel userModel;
  final UserModel currentUser;
  final PostModel postModel;
  const AddReaction(this.userID, this.postID, this.userModel, this.currentUser,
      this.postModel);
  @override
  List<Object?> get props => [userID, postID, postModel];
}

class DeletePost extends ExploreEvent {
  final String userID, postID;

  const DeletePost(this.userID, this.postID);
  @override
  List<Object?> get props => [userID, postID];
}

class GetPrayerRequestByPopularity extends ExploreEvent {
  @override
  List<Object?> get props => [];
}

class SearchPrayerRequest extends ExploreEvent {
  final String query;
  final List<PostModel> posts;

  const SearchPrayerRequest(this.query, this.posts);
  @override
  List<Object?> get props => [query, posts];
}

class CheckInternet extends ExploreEvent {
  final String type;

  const CheckInternet(this.type);
  @override
  List<Object?> get props => [type];
}
