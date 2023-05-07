import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? message;
  String? title;
  String? notificationId;
  Timestamp? timestamp;
  String? userId;
  bool? read;
  String? type;

  NotificationModel(
      {this.message,
      this.title,
      this.notificationId,
      this.timestamp,
      this.userId,
      this.type,
      this.read});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    title = json['title'];
    notificationId = json['notificationId'];
    timestamp = json['timestamp'];
    userId = json['user_id'];
    type = json['type'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['title'] = title;
    data['notificationId'] = notificationId;
    data['timestamp'] = timestamp;
    data['user_id'] = userId;
    data['type'] = type;
    data['read'] = read;
    return data;
  }
}
