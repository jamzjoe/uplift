import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_friendship_model.dart';

class UserApprovedMutualFriends {
  final UserFriendshipModel userFriendshipModel;
  final List<UserFriendshipModel> mutualFriends;

  UserApprovedMutualFriends(this.userFriendshipModel, this.mutualFriends);
}
