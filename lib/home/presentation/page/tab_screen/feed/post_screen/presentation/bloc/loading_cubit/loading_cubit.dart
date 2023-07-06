import 'package:flutter_bloc/flutter_bloc.dart';

enum LoadingStatus {
  initial,
  loading,
  loaded,
}

class FetchingLoadingCubit extends Cubit<LoadingStatus> {
  FetchingLoadingCubit() : super(LoadingStatus.initial);

  void setLoading() => emit(LoadingStatus.loading);

  void setLoaded() => emit(LoadingStatus.loaded);
}
