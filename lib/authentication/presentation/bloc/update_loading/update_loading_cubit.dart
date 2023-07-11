import 'package:bloc/bloc.dart';

enum LoadingState { idle, loading }

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState.idle);

  void showLoader() {
    emit(LoadingState.loading);
  }

  void hideLoader() {
    emit(LoadingState.idle);
  }
}
