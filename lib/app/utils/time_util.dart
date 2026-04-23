import 'package:intl/intl.dart';

class TimeUtil {
  TimeUtil._();

  static const String f1 = "yyyy-MM-dd HH:mm:ss";

  static String format(int timestamp, {String format = f1}) {
    timestamp = _timestampCover(timestamp);

    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat(format).format(date);
  }

  static int _timestampCover(int timestamp) {
    if (timestamp.toString().length == 10) {
      timestamp *= 1000; // 秒转毫秒
    }
    return timestamp;
  }

  static String formatToday(int timestamp) {
    // 判断时间戳是秒还是毫秒
    timestamp = _timestampCover(timestamp);

    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    // 判断是否是今天
    bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) {
      // 今天，显示时间
      return DateFormat('HH:mm').format(date);
    } else {
      // 非今天，显示日期
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }
}
