import 'package:flutter/material.dart';
import 'package:uplift/home/presentation/page/notifications/data/model/scheduled_notification_model.dart';

class NotificationList extends StatelessWidget {
  final List<ScheduledNotificationModel> notifications;
  final Function(int) onRemove;

  const NotificationList(
      {super.key, required this.notifications, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onRemove(notification.id);
              },
            ),
          );
        },
      ),
    );
  }
}
