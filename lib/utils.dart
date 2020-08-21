import 'package:intl/intl.dart';

const months = [
  'PLACEHOLDER',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class Utils {
  static String getTimeDiff(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds >= 0 && diff.inSeconds < 60) {
      time = 'Just Now';
    } else if (diff.inMinutes >= 1 && diff.inMinutes < 60) {
      time = diff.inMinutes.toString() + 'm ago';
    } else if (diff.inHours >= 1 && diff.inHours < 24) {
      time = diff.inHours.toString() + 'h ago';
    } else if (diff.inDays >= 1 && diff.inDays < 30) {
      if (diff.inDays >= 1 && diff.inDays < 7) {
        time = diff.inDays.toString() + 'd ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + 'w ago';
      }
    } else if (diff.inDays >= 30 && diff.inDays < 365) {
      time = (diff.inDays / 30).floor().toString() + 'mo ago';
    } else {
      time = (diff.inDays / 365).floor().toString() + 'y ago';
    }

    return time;
  }

  static String getDate(int timestamp) {
    return DateFormat('MMM dd, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
}
