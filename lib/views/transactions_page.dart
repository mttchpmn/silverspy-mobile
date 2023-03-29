import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final List<Transaction> _transactions = [
    Transaction(name: "Groceries", date: "2022-03-15", amount: 100.00),
    Transaction(name: "Gas", date: "2022-03-10", amount: 40.00),
    Transaction(name: "Phone bill", date: "2022-03-01", amount: 80.00),
    Transaction(name: "Internet bill", date: "2022-02-25", amount: 60.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction List"),
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return ListTile(
            title: Text(transaction.name),
            subtitle: Text(transaction.date),
            trailing: Text("\$${transaction.amount.toStringAsFixed(2)}"),
          );
        },
      ),
    );
  }
}
