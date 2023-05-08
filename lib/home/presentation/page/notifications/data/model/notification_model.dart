import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? message;
  String? title;
  String? notificationId;
  Timestamp? timestamp;
  String? senderID;
  String? receiverID;
  bool? read;
  String? type;

  NotificationModel(
      {this.message,
      this.title,
      this.notificationId,
      this.timestamp,
      this.senderID,
      this.type,
      this.read,
      this.receiverID});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    title = json['title'];
    notificationId = json['notificationId'];
    timestamp = json['timestamp'];
    senderID = json['sender_id'];
    receiverID = json['receiver_id'];
    type = json['type'];
    read = json['read'];
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
    return data;
  }
}
