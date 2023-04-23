part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GoogleSignInRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignOutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignIn extends AuthenticationEvent {
  final User user;

  const SignIn(this.user);
  @override
  List<Object?> get props => [user];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
