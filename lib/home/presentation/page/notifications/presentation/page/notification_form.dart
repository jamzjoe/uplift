import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../data/model/scheduled_notification_model.dart';

class NotificationForm extends StatefulWidget {
  final Function(ScheduledNotificationModel) onSchedule;
  final UserModel userModel;

  const NotificationForm(
      {super.key, required this.onSchedule, required this.userModel});

  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  @override
  void dispose() {
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
        _dateController.text = DateFormat('yyyy-MM-dd').format(date);
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
        _timeController.text = time.format(context);
      });
    }
  }

  void _scheduleNotification() {
    if (_selectedDate != null && _selectedTime != null) {
      final id = DateTime.now().millisecondsSinceEpoch;
      const title = 'Prayer Intention Reminder';
      const body =
          "Please take a moment to reflect on your prayer intentions and offer them up to the Divine. Remember to stay focused and open-hearted during your prayer time. May your intentions be heard and answered with grace.";
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
        _dateController.clear();
        _timeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          left: 30,
          top: 30,
          right: 30),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: whiteColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultText(
              text:
                  "Set a reminder for ${widget.userModel.displayName}'s prayer intention.",
              color: darkColor),
          defaultSpace,
          Container(
            decoration: BoxDecoration(
                color: lighter.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              onTap: _showDatePicker,
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                  hintText: 'Set date',
                  border: InputBorder.none,
                  icon: IconButton(
                      onPressed: _showDatePicker,
                      icon: const Icon(Ionicons.calendar))),
            ),
          ),
          defaultSpace,
          Container(
            decoration: BoxDecoration(
                color: lighter.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              onTap: _showTimePicker,
              readOnly: true,
              controller: _timeController,
              decoration: InputDecoration(
                  hintText: 'Set time',
                  border: InputBorder.none,
                  icon: IconButton(
                      onPressed: _showTimePicker,
                      icon: const Icon(Ionicons.time))),
            ),
          ),
          defaultSpace,
          CustomContainer(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              onTap: _scheduleNotification,
              widget: const SmallText(
                  textAlign: TextAlign.center,
                  text: 'Schedule Reminder',
                  color: whiteColor),
              color: primaryColor)
        ],
      ),
    );
  }
}
