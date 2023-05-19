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
  final String userName;
  const RegisterWithEmailAndPassword(
      this.email, this.password, this.bio, this.userName);

  @override
  List<Object?> get props => [email, password];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class UpdateBio extends AuthenticationEvent {
  final String userID, bio;

  const UpdateBio(this.userID, this.bio);
  @override
  List<Object?> get props => [userID, bio];
}

class DeleteAccount extends AuthenticationEvent {
  final User user;

  const DeleteAccount(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateProfile extends AuthenticationEvent {
  final String displayName, emailAddress, contactNo, bio, userID;
  final BuildContext context;

  const UpdateProfile(
      {required this.displayName,
      required this.emailAddress,
      required this.contactNo,
      required this.bio,
      required this.userID,
      required this.context});
  @override
  List<Object?> get props =>
      [displayName, emailAddress, contactNo, bio, userID, context];
}
