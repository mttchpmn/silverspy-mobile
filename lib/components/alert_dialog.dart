import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String label;
  final String detail;

  const Alert({super.key, required this.label, required this.detail});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(label),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(detail),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
