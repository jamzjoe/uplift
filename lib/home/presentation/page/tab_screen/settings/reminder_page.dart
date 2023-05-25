import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> _onSelectNotification(String payload) async {
    // Handle notification click event here
  }

  Future<void> _scheduleReminder(
      String repeatFrequency, TimeOfDay notificationTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'Channel Name',
            channelDescription: 'Channel Description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (repeatFrequency == 'Daily') {
      final tz.TZDateTime scheduledDateTime =
          _getNextInstanceOfTime(notificationTime);
      await flutterLocalNotificationsPlugin!
          .zonedSchedule(
            0,
            'Reminder Title',
            'This is your daily reminder',
            scheduledDateTime,
            platformChannelSpecifics,
            payload: 'payload',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.time,
          )
          .then((value) => log('Set daily successfully!'));
    } else if (repeatFrequency == 'Weekly') {
      final tz.TZDateTime scheduledDateTime =
          _getNextInstanceOfWeekly(notificationTime);
      await flutterLocalNotificationsPlugin!
          .zonedSchedule(
            0,
            'Reminder Title',
            'This is your weekly reminder',
            scheduledDateTime,
            platformChannelSpecifics,
            payload: 'payload',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          )
          .then((value) => log('Set weekly successfully!'));
    } else if (repeatFrequency == 'Specific Date') {
      final DateTime scheduledDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        notificationTime.hour,
        notificationTime.minute,
      );
      final tz.TZDateTime scheduledTZDateTime =
          tz.TZDateTime.from(scheduledDateTime, tz.local);
      await flutterLocalNotificationsPlugin!
          .zonedSchedule(
            0,
            'Reminder Title',
            'This is your specific date reminder',
            scheduledTZDateTime,
            platformChannelSpecifics,
            payload: 'payload',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
          )
          .then((value) => log('Set date successfully!'));
    }
  }

  tz.TZDateTime _getNextInstanceOfTime(TimeOfDay notificationTime) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  tz.TZDateTime _getNextInstanceOfWeekly(TimeOfDay notificationTime) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    final daysUntilNextInstance =
        (DateTime.sunday - scheduledDate.weekday + 7) % 7;
    final nextInstance =
        scheduledDate.add(Duration(days: daysUntilNextInstance));

    return nextInstance.isBefore(now)
        ? nextInstance.add(const Duration(days: 7))
        : nextInstance;
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    setState(() {
      selectedDate = selected;
    });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      selectedTime = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showTimePicker(context).then((_) {
                  if (selectedTime != null) {
                    _scheduleReminder('Daily', selectedTime!);
                  }
                });
              },
              child: const Text('Set Daily Reminder'),
            ),
            ElevatedButton(
              onPressed: () {
                _showTimePicker(context).then((_) {
                  if (selectedTime != null) {
                    _scheduleReminder('Weekly', selectedTime!);
                  }
                });
              },
              child: const Text('Set Weekly Reminder'),
            ),
            ElevatedButton(
              onPressed: () {
                _showDatePicker(context).then((_) {
                  if (selectedDate != null) {
                    _showTimePicker(context).then((_) {
                      if (selectedTime != null) {
                        _scheduleReminder('Specific Date', selectedTime!);
                      }
                    });
                  }
                });
              },
              child: const Text('Set Specific Date Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
