part of 'get_prayer_request_bloc.dart';

abstract class GetPrayerRequestEvent extends Equatable {
  const GetPrayerRequestEvent();
}

class GetPostRequestList extends GetPrayerRequestEvent {
  const GetPostRequestList();

  @override
  List<Object> get props => [];
}