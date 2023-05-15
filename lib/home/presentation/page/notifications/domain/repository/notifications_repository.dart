import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/notification_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/utils/services/auth_services.dart';

class NotificationRepository {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return _notification.show(id, title, body, await _notificationDetails());
  }

  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();
    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(initializeSettings);
  }

  static sendPushMessage(String token, String body, String title) async {
    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": token
    };
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'content-type': "application/json",
            'authorization':
                "key=AAAAI2vmS6A:APA91bFSQvC1qa-V1Av1joilMCC6KaHYb7gfFKly6ZysUBJ5WopswRVVLQxx12ceJJ6qdpf8SdYkj7PwaBctV4Rxm1zF-0-2YBC1WG2ugQpHZCQbftp6DZaTTDt7qeGhJiML9T_j3JJe"
          },
          body: jsonEncode(data));
      log("Successfully send");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> addNotification(
      String receiverID, String title, String message) async {
    CollectionReference notificationsCollection =
        FirebaseFirestore.instance.collection('Notifications');
    final currentUserID = await AuthServices.userID();
    try {
      // Generate a unique notification ID
      String notificationId = notificationsCollection.doc().id;

      final NotificationModel notificationModel = NotificationModel(
          notificationId: notificationId,
          senderID: currentUserID,
          receiverID: receiverID,
          title: title,
          read: false,
          message: message,
          timestamp: Timestamp.now());
      // Create the notification document
      await notificationsCollection
          .doc(notificationId)
          .set(notificationModel.toJson());
      log('Notification added successfully');
    } catch (e) {
      log('Error adding notification: $e');
    }
  }

  Future<List<UserNotifModel>> getUserNotifications(String userId) async {
    List<UserNotifModel> userNotif = [];

    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('Notifications')
        .orderBy('timestamp', descending: false)
        .where('receiver_id', isEqualTo: userId)
        .get();

    List<NotificationModel> data = response.docs
        .map((e) => NotificationModel.fromJson(e.data()))
        .toList()
        .reversed
        .toList();

    for (var each in data) {
      final UserModel user =
          await PrayerRequestRepository().getUserRecord(each.senderID!);
      userNotif.add(UserNotifModel(user, each));
    }

    return userNotif;
  }

  // Create a method to update the read status of this notification
  static Future<void> markAsRead(String notifID) async {
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(notifID)
        .update({"read": true});
  }

  // Create a method to update the read status of this notification
  static Future<void> delete(String notifID) async {
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(notifID)
        .delete();
  }
}
