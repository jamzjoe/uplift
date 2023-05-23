part of 'explore_get_prayer_request_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
}

class GetExplorePrayerRequestList extends ExploreEvent {
  final int? limit;
  const GetExplorePrayerRequestList({this.limit});

  @override
  List<Object> get props => [limit ?? ''];
}

class RefreshPostRequestList extends ExploreEvent {
  const RefreshPostRequestList();
  @override
  List<Object?> get props => [];
}

class AddReaction extends ExploreEvent {
  final String userID, postID;
  final UserModel userModel;
  final UserModel currentUser;
  const AddReaction(this.userID, this.postID, this.userModel, this.currentUser);
  @override
  List<Object?> get props => [userID, postID];
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

  const SearchPrayerRequest(this.query);
  @override
  List<Object?> get props => [query];
}

class CheckInternet extends ExploreEvent {
  final String type;

  const CheckInternet(this.type);
  @override
  List<Object?> get props => [type];
}
