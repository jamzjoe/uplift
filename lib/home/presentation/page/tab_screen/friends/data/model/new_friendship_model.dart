import 'package:uplift/authentication/data/model/user_model.dart';

class NewUserFriendshipModel {
  final FriendshipsID friendshipID;
  final UserModel userModel;
  final Status status;

  NewUserFriendshipModel(this.friendshipID, this.userModel, this.status);
}

class FriendshipsID {
  String? friendshipId;

  FriendshipsID({this.friendshipId});

  FriendshipsID.fromJson(Map<String, dynamic> json) {
    friendshipId = json['friendship_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['friendship_id'] = friendshipId;
    return data;
  }
}

class Status {
  String? friendshipID;
  String? status;

  Status({this.status, this.friendshipID});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    friendshipID = json['friendship_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['friendship_id'] = friendshipID;
    return data;
  }
}
