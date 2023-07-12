part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();
}

class UpdateProfileInformationEvent extends UpdateProfileEvent {
  final String displayName;
  final String emailAddress;
  final String contactNo;
  final String bio;
  final String userID;

  const UpdateProfileInformationEvent(
      {required this.displayName,
      required this.emailAddress,
      required this.contactNo,
      required this.bio,
      required this.userID});
  @override
  List<Object> get props => [displayName, emailAddress, contactNo, bio, userID];
}
