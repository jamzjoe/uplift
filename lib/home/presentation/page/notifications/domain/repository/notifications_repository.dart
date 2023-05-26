import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
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

  Stream<Map<String, dynamic>> notificationListener(String userID) {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .where('receiver_id', isEqualTo: userID)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return {'length': snapshot.docs.length};
    });
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

  static sendPushMessage(
      String token, String body, String title, String type) async {
    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "type": type
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

  Future<List<UserNotifModel>?> getUserNotifications(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          .orderBy('timestamp', descending: true)
          .where('receiver_id', isEqualTo: userId)
          .get();

      final notifications = querySnapshot.docs.map((doc) async {
        final notification = NotificationModel.fromJson(doc.data());
        final user = await PrayerRequestRepository()
            .getUserRecord(notification.senderID!);
        return UserNotifModel(user!, notification);
      });
      return await Future.wait(notifications.toList());
    } on FirebaseException catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Create a method to update the read status of this notification
  static Future<void> markAsRead(String notifID) async {
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(notifID)
        .update({"read": true});
  }

  // Create a method to update the read status of this notification
  Future<bool> markAllAsRead(String userID) async {
    final List<UserNotifModel>? notifications =
        await NotificationRepository().getUserNotifications(userID);

    try {
      if (notifications != null) {
        for (var each in notifications) {
          await FirebaseFirestore.instance
              .collection("Notifications")
              .doc(each.notificationModel.notificationId)
              .update({"read": true});
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create a method to update the read status of this notification
  Future<bool> deleteAll(String userID) async {
    final List<UserNotifModel>? notifications =
        await NotificationRepository().getUserNotifications(userID);

    try {
      if (notifications != null) {
        for (var each in notifications) {
          await FirebaseFirestore.instance
              .collection("Notifications")
              .doc(each.notificationModel.notificationId)
              .delete();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create a method to update the read status of this notification
  static Future<void> delete(String notifID) async {
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(notifID)
        .delete();
  }
}
