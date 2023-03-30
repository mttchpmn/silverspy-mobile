import 'package:flutter/material.dart';

import '../models/payment_model.dart';
import '../models/payment_input_model.dart';

class PaymentFormDialog extends StatefulWidget {
  final Function(PaymentInput) onFormSubmit;

  @override
  _PaymentFormDialogState createState() => _PaymentFormDialogState();

  PaymentFormDialog({super.key, required this.onFormSubmit});
}

class _PaymentFormDialogState extends State<PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _details = "";
  String _type = 'Incoming';
  String _frequency = 'Weekly';
  String _category = "";
  late DateTime _date;
  double _value = 0;

  void _handleFormSubmit() {
    var payment = PaymentInput(name: _name, referenceDate: _date.toString(), type: _type.toUpperCase(), frequency: _frequency.toUpperCase(),category: _category, details: _details, value: _value);

    widget.onFormSubmit(payment);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the payment';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category for the payment';
                  }
                  return null;
                },
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Details'),
                onSaved: (value) => _details = value!,
              ),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: InputDecoration(labelText: 'Type'),
                items: ['Incoming', 'Outgoing']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _frequency,
                decoration: InputDecoration(labelText: 'Frequency'),
                items: ['Weekly', 'Fortnightly', 'Monthly', 'Yearly']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _frequency = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value for the payment';
                  }
                  return null;
                },
                onSaved: (value) => _value = double.parse(value!),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Input Reference Date'),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _date = selectedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Add Payment'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _handleFormSubmit();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

