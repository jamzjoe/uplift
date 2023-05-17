part of 'post_prayer_request_bloc.dart';

abstract class PostPrayerRequestEvent extends Equatable {
  const PostPrayerRequestEvent();

  @override
  List<Object> get props => [];
}

class PostPrayerRequestActivity extends PostPrayerRequestEvent {
  final User user;
  final String text;
  final String title;
  final String name;
  final List<File> image;
  final List<UserFriendshipModel> approvedFriendsList;

  const PostPrayerRequestActivity(
      this.user, this.text, this.image, this.name, this.approvedFriendsList, this.title);
  @override
  List<Object> get props => [user, text, image, name, approvedFriendsList, title];
}
