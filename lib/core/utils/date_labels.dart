import 'package:intl/intl.dart';

/// Locale-aware date labels derived from the device clock (UI only).
abstract final class DateLabels {
  /// The next [count] days starting today.
  static List<DateTime> upcomingDays(int count, {DateTime? from}) {
    final start = from ?? DateTime.now();
    final today = DateTime(start.year, start.month, start.day);
    return [for (var i = 0; i < count; i++) today.add(Duration(days: i))];
  }

  /// Short weekday, e.g. "Mon".
  static String weekday(DateTime date, String locale) =>
      DateFormat.E(locale).format(date);

  /// Day of month, e.g. "15".
  static String day(DateTime date, String locale) =>
      DateFormat.d(locale).format(date);

  /// e.g. "15 Nov".
  static String dayMonth(DateTime date, String locale) =>
      DateFormat('d MMM', locale).format(date);

  /// e.g. "Sun, 15 Nov".
  static String weekdayDayMonth(DateTime date, String locale) =>
      DateFormat('EEE, d MMM', locale).format(date);
}
