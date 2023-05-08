part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GoogleSignInRequested extends AuthenticationEvent {
  final String bio;

  const GoogleSignInRequested(this.bio);

  @override
  List<Object> get props => [bio];
}

class SignOutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignIn extends AuthenticationEvent {
  final UserJoinedModel userJoinedModel;

  const SignIn(this.userJoinedModel);
  @override
  List<Object?> get props => [userJoinedModel];
}

class SignInWithEmailAndPassword extends AuthenticationEvent {
  final String email, password;
  final String bio;

  const SignInWithEmailAndPassword(this.email, this.password, this.bio);

  @override
  List<Object?> get props => [email, password];
}

class RegisterWithEmailAndPassword extends AuthenticationEvent {
  final String email, password;
  final String bio;
  const RegisterWithEmailAndPassword(this.email, this.password, this.bio);

  @override
  List<Object?> get props => [email, password];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
