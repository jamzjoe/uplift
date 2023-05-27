import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';

class UserMutualFriendsModel {
  final UserModel userFriendshipModel;
  final List<UserFriendshipModel> mutualFriends;

  UserMutualFriendsModel(this.userFriendshipModel, this.mutualFriends);
}
