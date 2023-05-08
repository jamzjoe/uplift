import 'package:firebase_auth/firebase_auth.dart';
import 'package:uplift/authentication/data/model/user_model.dart';

class UserJoinedModel {
  final UserModel userModel;
  final User user;

  UserJoinedModel(this.userModel, this.user);
}
