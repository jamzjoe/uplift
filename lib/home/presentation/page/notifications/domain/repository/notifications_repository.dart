import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/notification_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/payload_model.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/user_notif_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/post_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/full_post_view/full_post_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/services/auth_services.dart';

import '../../../tab_screen/friends/presentation/pages/your_friends/your_friends_screen.dart';

class NotificationRepository {
  static BuildContext? context;
  static Set<String> sentNotifications = <String>{};
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@drawable/ic_notification');
    var iosInitialize = const DarwinInitializationSettings();
    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(initializeSettings,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;

    if (payload != null) {
      debugPrint('notification payload: $payload');
      log('My payload:$payload');
    }

    final data = jsonDecode(payload!);
    final notifType = data['type'];

    if (notifType == notificationType.comment.name) {
      final postId = data['post_id'];
      final postUserID = data['post_user_id'];
      final postModel =
          await PostRepository().getEachPrayerIntention(postId, postUserID);
      final userID = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = await PrayerRequestRepository().getUserRecord(userID);
      openPrayerIntention(context!, postModel!.userModel,
          postModel.prayerRequestPostModel, currentUser!);
    } else if (notifType == notificationType.friend_request.name) {
      final currentUser =
          await PrayerRequestRepository().getUserRecord(data['current_user']);
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => YourFriendsScreen(user: currentUser!),
        ),
      );
    } else if (notifType == notificationType.post.name ||
        notifType == notificationType.react.name) {
      final decodedPayload = jsonDecode(payload);
      final timestampString = decodedPayload['date'];
      final timestamp = Timestamp.fromDate(DateTime.parse(timestampString));
      final text = decodedPayload['text'];
      final userId = decodedPayload['user_id'];
      final postId = decodedPayload['post_id'];
      final customName = decodedPayload['custom_name'];
      final title = decodedPayload['title'];

      final data = PrayerRequestPostModel(
        date: timestamp,
        text: text,
        userId: userId,
        postId: postId,
        name: customName,
        title: title,
      );

      final userID = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = await PrayerRequestRepository().getUserRecord(userID);
      final postUser = await PrayerRequestRepository().getUserRecord(userId);
      openPrayerIntention(context!, postUser!, data, currentUser!);
    }
  }

  static void openPrayerIntention(BuildContext context, UserModel user,
      PrayerRequestPostModel data, UserModel currentUser) {
    BlocProvider.of<EncourageBloc>(context)
        .add(FetchEncourageEvent(data.postId!));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPostView(
            postModel: PostModel(user, data), currentUser: currentUser),
      ),
    );
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'Uplift Notification',
            channelDescription: 'This notification is used for sending notif.',
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
    return _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future<void> sendPushMessage(String token, String body, String title,
      String type, String notificationData) async {
    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "type": type,
        "data": notificationData
      },
      "to": token
    };

    try {
      // Check if the notification has already been sent
      final notificationKey = jsonEncode(data);
      if (NotificationRepository.sentNotifications.contains(notificationKey)) {
        log("Notification already sent. Skipping...");
        return;
      }

      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'content-type': "application/json",
          'authorization':
              "key=AAAAI2vmS6A:APA91bFSQvC1qa-V1Av1joilMCC6KaHYb7gfFKly6ZysUBJ5WopswRVVLQxx12ceJJ6qdpf8SdYkj7PwaBctV4Rxm1zF-0-2YBC1WG2ugQpHZCQbftp6DZaTTDt7qeGhJiML9T_j3JJe"
        },
        body: jsonEncode(data),
      );

      // Store the sent notification in the history
      NotificationRepository.sentNotifications.add(notificationKey);

      log("Successfully sent notification");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> addNotification(
      String receiverID, String title, String message,
      {String? payload, String? type, String? postID}) async {
    CollectionReference notificationsCollection =
        FirebaseFirestore.instance.collection('Notifications');
    final currentUserID = await AuthServices.userID();
    try {
      // Generate a unique notification ID
      String notificationId = notificationsCollection.doc().id;

      if (type == 'comment') {
        notificationId = postID!;
      }

      final NotificationModel notificationModel = NotificationModel(
          notificationId: notificationId,
          senderID: currentUserID,
          receiverID: receiverID,
          title: title,
          read: false,
          type: type,
          postID: postID,
          message: message,
          payload: payload,
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

  Future<List<UserNotifModel>?> getUserNotifications(String userId,
      {int? limit}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          .orderBy('timestamp', descending: true)
          .where('receiver_id', isEqualTo: userId)
          .limit(limit ?? 15)
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
