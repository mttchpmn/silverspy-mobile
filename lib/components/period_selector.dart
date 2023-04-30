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

  const PeriodSelector({super.key, required this.fromDate, required this.toDate, required this.initialDatePeriod, required this.onPeriodChange});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _leftDate = _leftDate
                        .subtract(_getOffsetDuration(_selectedDatePeriod));
                    _rightDate = _rightDate
                        .subtract(_getOffsetDuration(_selectedDatePeriod));
                  });
                  widget.onPeriodChange(DatePeriod(_leftDate, _rightDate, _selectedDatePeriod));
                },
                icon: const Icon(Icons.chevron_left)),
            DropdownButton(
                value: _selectedDatePeriod,
                items: DatePeriodType.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (x) {
                  setState(() {
                    _selectedDatePeriod = x!;
                  });
                  widget.onPeriodChange(DatePeriod(_leftDate, _rightDate, _selectedDatePeriod));
                }),
            IconButton(
                onPressed: () {
                  setState(() {
                    _rightDate =
                        _rightDate.add(_getOffsetDuration(_selectedDatePeriod));
                    _leftDate =
                        _leftDate.add(_getOffsetDuration(_selectedDatePeriod));
                  });
                  widget.onPeriodChange(DatePeriod(_leftDate, _rightDate, _selectedDatePeriod));
                },
                icon: const Icon(Icons.chevron_right))
          ],
        ),
        Text(
            "Showing from ${DateHelper.getFormattedDate(_leftDate)} to ${DateHelper.getFormattedDate(_rightDate)}")
      ],
    );
  }

  Duration _getOffsetDuration(DatePeriodType type) {
    switch (type) {
      case DatePeriodType.Weekly:
        return const Duration(days: 7);
      // case DatePeriodType.Fortnightly:
      //   return const Duration(days: 14);
      // case DatePeriodType.Monthly:
      //   return const Duration();
    }
  }

}

enum DatePeriodType {
  Weekly,
  // Fortnightly,
  // Monthly,
  // Yearly,
  // PayPeriod
}
