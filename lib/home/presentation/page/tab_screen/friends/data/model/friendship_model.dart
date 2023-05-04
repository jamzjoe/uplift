import 'package:cloud_firestore/cloud_firestore.dart';

class FriendShipModel {
  String? sender;
  String? receiver;
  String? status;
  Timestamp? timestamp;

  FriendShipModel({this.sender, this.receiver, this.status, this.timestamp});

  FriendShipModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    receiver = json['receiver'];
    status = json['status'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['status'] = status;
    data['timestamp'] = timestamp;
    return data;
  }
}
