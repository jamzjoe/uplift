part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GoogleSignInRequested extends AuthenticationEvent {
  final String bio;
  final BuildContext context;
  final bool fromLogin;

  const GoogleSignInRequested(this.bio, this.context, this.fromLogin);

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
  final TextEditingController email, password;

  final String bio;
  final BuildContext context;

  const SignInWithEmailAndPassword(
      this.email, this.password, this.bio, this.context);

  @override
  List<Object?> get props => [email, password, context];
}

class RegisterWithEmailAndPassword extends AuthenticationEvent {
  final TextEditingController email, password, confirm;
  final String bio;
  final TextEditingController userName;
  final BuildContext context;
  const RegisterWithEmailAndPassword(this.email, this.password, this.bio,
      this.userName, this.context, this.confirm);

  @override
  List<Object?> get props => [email, password, bio, userName, context];
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
  final BuildContext? context;
  final String password;
  const DeleteAccount(this.password, {this.context});

  @override
  List<Object?> get props => [password, context];
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
