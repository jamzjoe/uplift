part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class UserIsIn extends AuthenticationState {
  final UserJoinedModel userJoinedModel;

  const UserIsIn(this.userJoinedModel);
  @override
  List<Object> get props => [userJoinedModel];
}

class UserIsOut extends AuthenticationState {
  final String message;

  const UserIsOut(this.message);
  @override
  List<Object> get props => [];
}

class Loading extends AuthenticationState {}
