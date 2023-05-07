import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverspy/helpers/date_helper.dart';

class DatePeriod {
  final DateTime to;
  final DateTime from;
  final DatePeriodType type;

  DatePeriod(this.from, this.to, this.type);
}

class PeriodSelector extends StatefulWidget {
  final ValueChanged<DatePeriod> onPeriodChange;
  final DateTime fromDate;
  final DateTime toDate;
  final DatePeriodType initialDatePeriod;

  const PeriodSelector(
      {super.key,
      required this.fromDate,
      required this.toDate,
      required this.initialDatePeriod,
      required this.onPeriodChange});

  @override
  State<StatefulWidget> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  late DatePeriodType _selectedDatePeriod;
  late DateTime _leftDate;
  late DateTime _rightDate;

  @override
  void initState() {
    super.initState();

    _initDates();
  }

  void _initDates() {
    setState(() {
      _selectedDatePeriod = widget.initialDatePeriod;
      _leftDate = widget.fromDate;
      _rightDate = widget.toDate;
    });
  }

  void _setDates() {
    var period = DateHelper.getDatePeriodForType(_selectedDatePeriod);

    setState(() {
      _leftDate = period.from;
      _rightDate = period.to;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  _handleLeftButtonPress();
                },
                icon: const Icon(Icons.chevron_left)),
            DropdownButton(
                value: _selectedDatePeriod,
                items: _getDatePeriodValues(),
                onChanged: (x) {
                  _handlePeriodChange(x);
                }),
            IconButton(
                onPressed: () {
                  _handleRightButtonPress();
                },
                icon: const Icon(Icons.chevron_right))
          ],
        ),
        Text(
            "Showing from ${DateHelper.getFormattedDate(_leftDate)} to ${DateHelper.getFormattedDate(_rightDate)}")
      ],
    );
  }

  List<DropdownMenuItem<DatePeriodType>> _getDatePeriodValues() {
    return DatePeriodType.values
        .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
        .toList();
  }

  void _handlePeriodChange(DatePeriodType? x) {
    setState(() {
      _selectedDatePeriod = x!;
    });
    _setDates();
    widget
        .onPeriodChange(DatePeriod(_leftDate, _rightDate, _selectedDatePeriod));
  }

  void _handleRightButtonPress() {
    setState(() {
      _rightDate = _rightDate.add(_getOffsetDuration(_selectedDatePeriod));
      _leftDate = _leftDate.add(_getOffsetDuration(_selectedDatePeriod));
    });
    widget
        .onPeriodChange(DatePeriod(_leftDate, _rightDate, _selectedDatePeriod));
  }

  void _handleLeftButtonPress() {
    setState(() {
      _leftDate = _leftDate.subtract(_getOffsetDuration(_selectedDatePeriod));
      _rightDate = _rightDate.subtract(_getOffsetDuration(_selectedDatePeriod));
    });
    widget
        .onPeriodChange(DatePeriod(_leftDate, _rightDate, _selectedDatePeriod));
  }

  Duration _getOffsetDuration(DatePeriodType type) {
    switch (type) {
      case DatePeriodType.Weekly:
        return const Duration(days: 7);
      case DatePeriodType.Fortnightly:
        return const Duration(days: 14);
      case DatePeriodType.Monthly:
        var now = DateTime.now();
        var year = now.year;
        var month = now.month;
        var daysInMonth = DateTime(year, month + 1, 0).day;

        return Duration(days: daysInMonth);
    }
  }

}

enum DatePeriodType {
  Weekly,
  Fortnightly,
  Monthly,
  // Yearly,
  // PayPeriod
}
