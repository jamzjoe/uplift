import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uplift/home/presentation/page/notifications/domain/repository/notifications_repository.dart';

class Initialize {
  void listenIncomingNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data['data']}');

      if (message.notification != null) {
        NotificationRepository.showNotification(
            payload: message.data['data'],
            id: message.notification.hashCode,
            title: message.notification!.title,
            body: message.notification!.body);
      }
    }).onError((handleError) {
      log(handleError);
    });
  }

  Future<String?> getFCMToken() async {
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      log("Error getting FCM token: $e");
    }
    return token;
  }

  Future<NotificationSettings> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');

    return settings;
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    if (message.data.containsKey('event') &&
        message.data['event'] == 'token_refresh') {
      // Refresh FCM token in the background
      updateFCMTokenInBackground();
    }
  }

  void registerBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  void updateFCMTokenInBackground() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final token = await messaging.getToken();

    // Update the token in Firestore for the current user
    // Assuming you have a 'users' collection in Firestore
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .update({'device_token': token}).then((_) {
      log('FCM token updated successfully in Firestore');
    }).catchError((error) {
      log('Failed to update FCM token in Firestore: $error');
    });
  }
}
