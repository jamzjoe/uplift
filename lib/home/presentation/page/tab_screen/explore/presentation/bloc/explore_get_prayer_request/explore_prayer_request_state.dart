part of 'explore_get_prayer_request_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
}

class GetPrayerRequestInitial extends ExploreState {
  @override
  List<Object?> get props => [];
}

class LoadingPrayerRequesList extends ExploreState {
  @override
  List<Object?> get props => [];
}

class LoadingPrayerRequesListSuccess extends ExploreState {
  final List<PostModel> prayerRequestPostModel;

  const LoadingPrayerRequesListSuccess(this.prayerRequestPostModel);
  @override
  List<Object> get props => [prayerRequestPostModel];
}

class LoadingPrayerRequesListError extends ExploreState {
  @override
  List<Object> get props => [];
}

class NoInternetConnnection extends ExploreState {
  @override
  List<Object?> get props => [];
}
