part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}



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
  List<Object> get props => [message];
}

class Loading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}
