import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? message;
  String? title;
  String? notificationId;
  Timestamp? timestamp;
  String? userId;
  String? type;

  NotificationModel(
      {this.message,
      this.title,
      this.notificationId,
      this.timestamp,
      this.userId,
      this.type});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    title = json['title'];
    notificationId = json['notificationId'];
    timestamp = json['timestamp'];
    userId = json['userId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['title'] = title;
    data['notificationId'] = notificationId;
    data['timestamp'] = timestamp;
    data['userId'] = userId;
    data['type'] = type;
    return data;
  }
}
