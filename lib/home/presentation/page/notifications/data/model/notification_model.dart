import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? message;
  String? title;
  String? notificationId;
  Timestamp? timestamp;
  String? senderID;
  String? postID;
  String? receiverID;
  bool? read;
  String? type;
  String? payload;

  NotificationModel(
      {this.message,
      this.title,
      this.notificationId,
      this.timestamp,
      this.senderID,
      this.type,
      this.read,
      this.postID,
      this.receiverID,
      this.payload});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    title = json['title'];
    notificationId = json['notificationId'];
    timestamp = json['timestamp'];
    senderID = json['sender_id'];
    receiverID = json['receiver_id'];
    type = json['type'];
    read = json['read'];
    payload = json['payload'];
    postID = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['title'] = title;
    data['notificationId'] = notificationId;
    data['timestamp'] = timestamp;
    data['sender_id'] = senderID;
    data['receiver_id'] = receiverID;
    data['type'] = type;
    data['read'] = read;
    data['payload'] = payload;
    data['post_id'] = postID;
    return data;
  }
}
