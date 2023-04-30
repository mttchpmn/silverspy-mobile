import 'package:intl/intl.dart';

import '../components/period_selector.dart';

class DateHelper {

  static DatePeriod getWeekPeriod() {
    var reference = DateTime.now();
    var startOfWeek = reference.subtract(Duration(days: reference.weekday - 1));
    var endOfWeek =
    reference.add(Duration(days: DateTime.daysPerWeek - reference.weekday));

    return DatePeriod(startOfWeek, endOfWeek, DatePeriodType.Weekly);
  }

  static String getFormattedDate(DateTime date) =>
      DateFormat.yMMMMd('en_US').format(date.toLocal());
}