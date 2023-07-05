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
  final List<UserFriendshipModel> approvedFriendsList;
  final BuildContext context;

  const PostPrayerRequestActivity(this.user, this.text, this.name,
      this.approvedFriendsList, this.title, this.context);
  @override
  List<Object> get props =>
      [user, text, name, approvedFriendsList, title];
}
