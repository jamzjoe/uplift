part of 'get_prayer_request_bloc.dart';

abstract class GetPrayerRequestState extends Equatable {
  const GetPrayerRequestState();
}

class GetPrayerRequestInitial extends GetPrayerRequestState {
  @override
  List<Object?> get props => [];
}

class LoadingPrayerRequesList extends GetPrayerRequestState {
  @override
  List<Object?> get props => [];
}

class LoadingPrayerRequesListSuccess extends GetPrayerRequestState {
  final List<PrayerRequestPostModel> prayerRequestPostModel;

  const LoadingPrayerRequesListSuccess(this.prayerRequestPostModel);
  @override
  List<Object> get props => [prayerRequestPostModel];
}

class LoadingPrayerRequesListError extends GetPrayerRequestState {
  @override
  List<Object> get props => [];
}
