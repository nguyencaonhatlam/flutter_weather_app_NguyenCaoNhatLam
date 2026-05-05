import 'package:intl/intl.dart';

class DateFormatter {
  // 🌍 Locale mặc định (có thể đổi)
  static const String locale = 'vi_VN';

  // 📅 Thứ + ngày đầy đủ
  static String formatFull(DateTime date) {
    return DateFormat('EEEE, d MMM', locale).format(date);
  }

  // 📅 Ngày ngắn
  static String formatShort(DateTime date) {
    return DateFormat('dd MMM', locale).format(date);
  }

  // ⏰ Giờ (hỗ trợ 12h / 24h)
  static String formatTime(DateTime date, {bool is24Hour = true}) {
    if (is24Hour) {
      return DateFormat('HH:mm', locale).format(date);
    } else {
      return DateFormat('hh:mm a', locale).format(date);
    }
  }

  // 📆 Thứ
  static String formatDay(DateTime date) {
    return DateFormat('EEEE', locale).format(date);
  }

  // 🔄 Unix → DateTime
  static DateTime fromUnix(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  // 🌤 Check ngày / đêm
  static bool isDayTime(DateTime sunrise, DateTime sunset) {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }
}