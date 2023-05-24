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
  String? status;

  Status({this.status});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}
