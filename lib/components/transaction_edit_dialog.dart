import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class EditTransactionDialog extends StatefulWidget {
  final Transaction transaction;
  final ValueChanged<Transaction> onSaveHandler;
  final VoidCallback leftSwipeHandler;
  final VoidCallback rightSwipeHandler;

  EditTransactionDialog(
      {required this.transaction,
      required this.onSaveHandler,
      required this.leftSwipeHandler,
      required this.rightSwipeHandler});

  @override
  _EditTransactionDialogState createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late Transaction _transaction;
  late String _selectedCategory;
  late String _details;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
    _selectedCategory = widget.transaction.category;
    _details = widget.transaction.details ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var categories = <String>[
      "UNCATEGORIZED",
      "RENT",
      "UTILITIES",
      "GROCERIES",
      "TRANSPORTATION",
      "INSURANCE",
      "HEALTHCARE",
      "REPAYMENTS",
      "SAVINGS",
      "INVESTMENT",
      "SUBSCRIPTIONS",
      "SHOPPING",
      "FOODANDDRINK",
      "RECREATION",
      "PERSONAL",
      "MISCELLANEOUS",
    ];

    return Dialog(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            widget.leftSwipeHandler();
          } else if (details.primaryVelocity! < 0) {
            widget.rightSwipeHandler();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text(widget.transaction.reference),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text(widget.transaction.description),
            ),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text(widget.transaction.type),
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text(DateFormat.yMMMMd('en_US').format(
                  DateTime.parse(widget.transaction.transactionDate)
                      .toLocal())),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Details',
                ),
                onChanged: (value) {
                  setState(() {
                    _details = value;
                  });
                },
                controller:
                    TextEditingController(text: widget.transaction.details),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('\$${widget.transaction.value.toStringAsFixed(2)}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    _transaction.category = _selectedCategory;
                    _transaction.details = _details;
                    widget.onSaveHandler(_transaction);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
