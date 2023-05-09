import 'package:intl/intl.dart';

class DateFeature {
  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just Now';
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }
}
