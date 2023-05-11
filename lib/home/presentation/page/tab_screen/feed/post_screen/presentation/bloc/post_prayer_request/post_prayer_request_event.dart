part of 'post_prayer_request_bloc.dart';

abstract class PostPrayerRequestEvent extends Equatable {
  const PostPrayerRequestEvent();

  @override
  List<Object> get props => [];
}

class PostPrayerRequestActivity extends PostPrayerRequestEvent {
  final User user;
  final String text;
  final File image;

  const PostPrayerRequestActivity(this.user, this.text, this.image);
  @override
  List<Object> get props => [user, text];
}
