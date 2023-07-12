part of 'update_profile_bloc.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final UserJoinedModel userJoinedModel;

  const UpdateProfileSuccess(this.userJoinedModel);
}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileError extends UpdateProfileState {}
