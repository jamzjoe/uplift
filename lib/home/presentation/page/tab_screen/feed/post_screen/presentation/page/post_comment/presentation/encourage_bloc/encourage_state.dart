part of 'encourage_bloc.dart';

abstract class EncourageState extends Equatable {
  const EncourageState();
}

class EncourageInitial extends EncourageState {
  @override
  List<Object> get props => [];
}

class LoadingEncourages extends EncourageState {
  const LoadingEncourages();

  @override
  List<Object?> get props => [];
}

class LoadingEncouragesSuccess extends EncourageState {
  final List<UserCommentModel> encourages;

  const LoadingEncouragesSuccess(this.encourages);

  @override
  List<Object?> get props => [encourages];
}

class LoadingEncouragesError extends EncourageState {
  const LoadingEncouragesError();

  @override
  List<Object?> get props => [];
}
