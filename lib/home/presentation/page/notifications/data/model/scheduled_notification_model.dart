class ScheduledNotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime dateTime;

  ScheduledNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
  });
}
