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

    return DatePeriod(startOfWeek, endOfWeek, DatePeriodType.Weekly);
  }

  static DatePeriod getFortnightPeriod() {
    var reference = DateTime.now().toLocal();
    var startOfPeriod = reference
        .subtract(Duration(days: reference.weekday - 1))
        .subtract(const Duration(days: 7));
    var endOfWeek =
        reference.add(Duration(days: DateTime.daysPerWeek - reference.weekday));

    return DatePeriod(startOfPeriod, endOfWeek, DatePeriodType.Fortnightly);
  }

  static DatePeriod getMonthPeriod() {
    var now = DateTime.now().toLocal();
    var startOfMonth = DateTime(now.year, now.month, 1);
    var endOfMonth = DateTime(now.year, now.month + 1, 0);

    debugPrint("Start: ${startOfMonth.toIso8601String()}");
    debugPrint("End: ${endOfMonth.toIso8601String()}");

    return DatePeriod(startOfMonth, endOfMonth, DatePeriodType.Monthly);
  }

  static String getFormattedDate(DateTime date) =>
      DateFormat.yMMMMd('en_US').format(date.toLocal());
}
