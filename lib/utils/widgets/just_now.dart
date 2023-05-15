import 'package:intl/intl.dart';

class DateFeature {
  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just Now';
    } else if (difference.inMinutes < 2) {
      return '1 minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 2) {
      return '1 hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 2) {
      return '1 day ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }
}
