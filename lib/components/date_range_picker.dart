import 'package:flutter/material.dart';

class DateRangePickerWidget extends StatefulWidget {
  final ValueChanged<DateTime> fromDateCallback;
  final ValueChanged<DateTime> toDateCallback;

  const DateRangePickerWidget({
    Key? key,
    required this.fromDateCallback,
    required this.toDateCallback,
  }) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  late DateTime _fromDate;
  late DateTime _toDate;

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _fromDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _fromDate) {
                setState(() {
                  _fromDate = picked;
                  widget.fromDateCallback(picked);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'From: ${_fromDate.day}/${_fromDate.month}/${_fromDate.year}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _toDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _toDate) {
                setState(() {
                  _toDate = picked;
                  widget.toDateCallback(picked);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'To: ${_toDate.day}/${_toDate.month}/${_toDate.year}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
