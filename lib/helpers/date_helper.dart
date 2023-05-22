import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../components/period_selector.dart';

class DateHelper {
  static DatePeriod getDatePeriodForType(DatePeriodType type) {
    switch (type) {
      case DatePeriodType.Weekly:
        return getWeekPeriod();
      case DatePeriodType.Fortnightly:
        return getFortnightPeriod();
      case DatePeriodType.Monthly:
        return getMonthPeriod();
    }
  }

  static DatePeriod getWeekPeriod() {
    var reference = DateTime.now().toLocal();
    var startOfWeek = reference.subtract(Duration(days: reference.weekday - 1));
    var endOfWeek =
        reference.add(Duration(days: DateTime.daysPerWeek - reference.weekday));

    var start = getStartOfDay(startOfWeek);
    var end = getEndOfDay(endOfWeek);

    return DatePeriod(start, end, DatePeriodType.Weekly);
  }

  static DatePeriod getFortnightPeriod() {
    var reference = DateTime.now().toLocal();
    var startOfPeriod = reference
        .subtract(Duration(days: reference.weekday - 1))
        .subtract(const Duration(days: 7));
    var endOfWeek =
        reference.add(Duration(days: DateTime.daysPerWeek - reference.weekday));

    var start = getStartOfDay(startOfPeriod);
    var end = getEndOfDay(endOfWeek);

    return DatePeriod(start, end, DatePeriodType.Fortnightly);
  }

  static DatePeriod getMonthPeriod() {
    var now = DateTime.now().toLocal();
    var startOfMonth = getStartOfDay(DateTime(now.year, now.month, 1));
    var endOfMonth = getEndOfDay(DateTime(now.year, now.month + 1, 0));

    debugPrint("Start: ${startOfMonth.toIso8601String()}");
    debugPrint("End: ${endOfMonth.toIso8601String()}");

    return DatePeriod(startOfMonth, endOfMonth, DatePeriodType.Monthly);
  }

  static DateTime getStartOfDay(DateTime ref) {
    return DateTime(ref.year, ref.month, ref.day);
  }

  static DateTime getEndOfDay(DateTime ref) {
    var startOfDay = DateTime(ref.year, ref.month, ref.day);
    var endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    return endOfDay;
  }

  static String getFormattedDate(DateTime date) =>
      DateFormat.yMMMMd('en_US').format(date.toLocal());
}
