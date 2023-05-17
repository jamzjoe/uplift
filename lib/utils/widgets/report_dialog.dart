import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class ReportPrayerRequestDialog extends StatefulWidget {
  const ReportPrayerRequestDialog({super.key});

  @override
  _ReportPrayerRequestDialogState createState() =>
      _ReportPrayerRequestDialogState();
}

class _ReportPrayerRequestDialogState extends State<ReportPrayerRequestDialog> {
  String? selectedReport;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Prayer Request'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('Please select a reason for reporting:'),
            const SizedBox(height: 16.0),
            _buildReportChoice('Inappropriate Content'),
            _buildReportChoice('Spam'),
            _buildReportChoice('Irrelevant'),
            _buildReportChoice('Other'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const SmallText(text: 'REPORT', color: whiteColor),
          onPressed: () {
            // Perform the action to report the prayer request
            if (selectedReport != null) {
              print('Selected Report: $selectedReport');
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildReportChoice(String choice) {
    final bool isSelected = selectedReport == choice;
    return ListTile(
      title: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.green : null,
          ),
          const SizedBox(width: 8.0),
          Text(choice),
        ],
      ),
      onTap: () {
        setState(() {
          selectedReport = choice;
        });
      },
    );
  }
}
