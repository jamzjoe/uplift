part of 'post_prayer_request_bloc.dart';

abstract class PostPrayerRequestState extends Equatable {
  const PostPrayerRequestState();

  @override
  List<Object> get props => [];
}

class PostPrayerRequestInitial extends PostPrayerRequestState {}

class PostPrayerRequestLoading extends PostPrayerRequestState {}

class PostPrayerRequestSuccess extends PostPrayerRequestState {}

class PostPrayerRequestError extends PostPrayerRequestState {}
