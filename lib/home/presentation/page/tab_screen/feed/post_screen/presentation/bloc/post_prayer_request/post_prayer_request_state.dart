part of 'post_prayer_request_bloc.dart';

abstract class PostPrayerRequestState extends Equatable {
  const PostPrayerRequestState();
}

class PostPrayerRequestInitial extends PostPrayerRequestState {
  @override
  List<Object> get props => [];
}

class PostPrayerRequestLoading extends PostPrayerRequestState {
  @override
  List<Object> get props => [];
}

class PostPrayerRequestSuccess extends PostPrayerRequestState {
  @override
  List<Object> get props => [];
}

class PostPrayerRequestError extends PostPrayerRequestState {
  @override
  List<Object> get props => [];
}

class Posted extends PostPrayerRequestState {
  @override
  List<Object?> get props => [];
}
