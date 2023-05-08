import 'package:cloud_firestore/cloud_firestore.dart';

class FriendShipModel {
  String? sender;
  String? receiver;
  String? status;
  Timestamp? timestamp;
  String? friendshipID;

  FriendShipModel(
      {this.sender,
      this.receiver,
      this.status,
      this.timestamp,
      this.friendshipID});

  FriendShipModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    receiver = json['receiver'];
    status = json['status'];
    timestamp = json['timestamp'];
    friendshipID = json['friendship_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['status'] = status;
    data['timestamp'] = timestamp;
    data['friendship_id'] = friendshipID;
    return data;
  }
}
