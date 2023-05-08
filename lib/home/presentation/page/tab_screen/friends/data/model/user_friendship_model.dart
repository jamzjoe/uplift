import 'package:uplift/authentication/data/model/user_model.dart';

class UserFriendshipModel {
  final FriendshipID friendshipID;
  final UserModel userModel;

  UserFriendshipModel(this.friendshipID, this.userModel);
}

class FriendshipID {
  String? friendshipId;

  FriendshipID({this.friendshipId});

  FriendshipID.fromJson(Map<String, dynamic> json) {
    friendshipId = json['friendship_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['friendship_id'] = friendshipId;
    return data;
  }
}
