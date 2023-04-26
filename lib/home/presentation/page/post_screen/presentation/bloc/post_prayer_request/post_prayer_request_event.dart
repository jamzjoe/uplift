part of 'post_prayer_request_bloc.dart';

abstract class PostPrayerRequestEvent extends Equatable {
  const PostPrayerRequestEvent();

  @override
  List<Object> get props => [];
}

class PostPrayerRequest extends PostPrayerRequestEvent {
  final User user;
  final String text;

  const PostPrayerRequest(this.user, this.text);
   @override
  List<Object> get props => [user, text];
}
