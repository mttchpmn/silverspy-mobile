import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverspy/components/transaction_edit_dialog.dart';
import 'package:silverspy/models/transaction_response_model.dart';
import 'package:silverspy/services/transaction_service.dart';

import '../helpers/icon_helper.dart';
import '../models/transaction_model.dart';

class TransactionListPage extends StatefulWidget {
  final String title;
  final List<Transaction> transactionResponse;
  final ValueChanged<Transaction> onTransactionUpdated;

  const TransactionListPage({Key? key, required this.title, required this.transactionResponse, required this.onTransactionUpdated})
      : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TransactionsList(transactions: widget.transactionResponse, onTransactionUpdated: widget.onTransactionUpdated),
          ],
        ));
  }
}

class TransactionsList extends StatefulWidget {
  final List<Transaction> transactions;
  final ValueChanged<Transaction> onTransactionUpdated;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.onTransactionUpdated
  });

  @override
  State<StatefulWidget> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  late List<Transaction> transactions;

  _TransactionsListState();

  @override
  Widget build(BuildContext context) {
    transactions = widget.transactions;

    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
            var transaction = transactions[index];

          return ListTile(
            leading:
                IconHelper.getIconForCategory(transaction.category),
            title: Text(transaction.reference),
            subtitle: Text(DateFormat.yMMMMd('en_US').format(
                DateTime.parse(transaction.transactionDate)
                    .toLocal())),
            trailing: Text('\$${transaction.value}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditTransactionDialog(
                    transaction: transaction,
                    leftSwipeHandler: () {
                      debugPrint("Swiped left");
                    },
                    rightSwipeHandler: () {
                      debugPrint("Swiped right");
                    },
                    onSaveHandler: (updatedTransaction) async {
                      debugPrint(updatedTransaction.toString());
                      setState(() {
                        transactions[index] = updatedTransaction;
                      });
                       widget.onTransactionUpdated(updatedTransaction);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
