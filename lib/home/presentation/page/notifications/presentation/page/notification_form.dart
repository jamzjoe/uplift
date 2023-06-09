import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../data/model/scheduled_notification_model.dart';

class NotificationForm extends StatefulWidget {
  final Function(ScheduledNotificationModel) onSchedule;

  const NotificationForm({super.key, required this.onSchedule});

  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _scheduleNotification() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      final id = DateTime.now().millisecondsSinceEpoch;
      final title = _titleController.text;
      final body = _bodyController.text;
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final notification = ScheduledNotificationModel(
        id: id,
        title: title,
        body: body,
        dateTime: dateTime,
      );

      widget.onSchedule(notification);

      setState(() {
        _titleController.text = '';
        _bodyController.text = '';
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 30,
          top: 15,
          right: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Reminder Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a reminder title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a reminder description';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date:'),
                const SizedBox(width: 8),
                Text(_selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    : 'Not selected'),
                const SizedBox(width: 8),
                TextButton.icon(
                    label:
                        const SmallText(text: 'Select Date', color: darkColor),
                    onPressed: _showDatePicker,
                    icon: const Icon(Ionicons.calendar)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time:'),
                const SizedBox(width: 8),
                Text(_selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Not selected'),
                const SizedBox(width: 8),
                TextButton.icon(
                    label:
                        const SmallText(text: 'Select time', color: darkColor),
                    onPressed: _showTimePicker,
                    icon: const Icon(Ionicons.time)),
              ],
            ),
            CustomContainer(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                onTap: _scheduleNotification,
                widget: const SmallText(
                    textAlign: TextAlign.center,
                    text: 'Schedule Reminder',
                    color: whiteColor),
                color: primaryColor)
          ],
        ),
      ),
    );
  }
}
