import 'dart:convert';
import 'dart:developer';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/scheduled_notification_model.dart';

class ScheduledNotificationManager {
  static const _kNotificationsKey = 'scheduled_notifications';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final SharedPreferences sharedPreferences;

  ScheduledNotificationManager(
    this.flutterLocalNotificationsPlugin,
    this.sharedPreferences,
  );

  List<ScheduledNotificationModel> getNotifications() {
    try {
      final notificationsJson =
          sharedPreferences.getStringList(_kNotificationsKey);
      if (notificationsJson != null) {
        return notificationsJson.map((json) {
          final notificationData = jsonDecode(json);
          return ScheduledNotificationModel(
            id: notificationData['id'],
            title: notificationData['title'],
            body: notificationData['body'],
            dateTime: DateTime.parse(notificationData['dateTime']),
          );
        }).toList();
      }
    } catch (e, stackTrace) {
      log('Error while fetching notifications: $e', stackTrace: stackTrace);
    }
    return [];
  }

  void addNotification(ScheduledNotificationModel notification) {
    try {
      final notifications = getNotifications();
      notifications.add(notification);
      _saveNotifications(notifications);
      _scheduleNotification(notification);
    } catch (e, stackTrace) {
      log('Error while adding notification: $e', stackTrace: stackTrace);
    }
  }

  void removeNotification(int id) {
    try {
      final notifications = getNotifications();
      notifications.removeWhere((notification) => notification.id == id);
      _saveNotifications(notifications);
    } catch (e, stackTrace) {
      log('Error while removing notification: $e', stackTrace: stackTrace);
    }
  }

  void _saveNotifications(List<ScheduledNotificationModel> notifications) {
    try {
      final notificationsJson = notifications
          .map((notification) => jsonEncode({
                'id': notification.id,
                'title': notification.title,
                'body': notification.body,
                'dateTime': notification.dateTime.toIso8601String(),
              }))
          .toList();
      sharedPreferences.setStringList(_kNotificationsKey, notificationsJson);
    } catch (e, stackTrace) {
      log('Error while saving notifications: $e', stackTrace: stackTrace);
    }
  }

  void _scheduleNotification(ScheduledNotificationModel notification) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
      );
      const iOSPlatformChannelSpecifics = DarwinInitializationSettings();
      const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(),
      );

      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        notification.dateTime,
        tz.local,
      );
      final int id = notification.dateTime.millisecondsSinceEpoch % 2147483647;

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        notification.title,
        notification.body,
        scheduledDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: 'scheduledNotification',
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e, stackTrace) {
      log('Error while scheduling notification: $e', stackTrace: stackTrace);
    }
  }

  void scheduleAllNotifications() {
    final notifications = getNotifications();
    for (final notification in notifications) {
      _scheduleNotification(notification);
    }
  }
}
