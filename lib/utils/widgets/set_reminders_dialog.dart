import 'package:flutter/material.dart';

class SetReminderDialog extends StatelessWidget {
  final TextEditingController _reminderController = TextEditingController();

  SetReminderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Reminder'),
      content: TextField(
        controller: _reminderController,
        decoration: const InputDecoration(
          labelText: 'Reminder',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Set'),
          onPressed: () {
            String reminder = _reminderController.text;
            // Here you can implement your logic to handle the reminder, such as saving it to a database
            // or triggering a notification

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
