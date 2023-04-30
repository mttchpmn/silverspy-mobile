import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/components/date_range_picker.dart';
import 'package:silverspy/components/period_selector.dart';
import 'package:silverspy/components/transaction_category_total_list.dart';
import 'package:silverspy/helpers/date_helper.dart';
import 'package:silverspy/models/transaction_response_model.dart';
import 'package:silverspy/views/payments_list_page.dart';
import 'package:silverspy/views/transactions_list_page.dart';

import '../components/loading_spinner.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';
import '../services/transaction_service.dart';

class TransactionsOverviewPage extends StatefulWidget {
  const TransactionsOverviewPage({super.key});

  @override
  _TransactionsOverviewPageState createState() =>
      _TransactionsOverviewPageState();
}

class _TransactionsOverviewPageState extends State<TransactionsOverviewPage> {
  final TransactionService _transactionService = TransactionService();

  late DateTime _toDate;
  late DateTime _fromDate;
  late DatePeriodType _datePeriod;

  late Future<TransactionResponse> _transactionResponse;

  @override
  void initState() {
    super.initState();

    _transactionResponse = _getTransactionResponse();
    var weekPeriod = DateHelper.getWeekPeriod();

    setState(() {
      _toDate = weekPeriod.to;
      _fromDate = weekPeriod.from;
      _datePeriod = DatePeriodType.Weekly;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _transactionResponse = _getTransactionResponse();
  }

  Future<void> _syncTransactions() async {
    debugPrint("Syncing transactions...");
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      return _transactionService.syncTransactions(value.accessToken);
    });
  }

  Future<Transaction> _updateTransaction(Transaction updatedTransaction) {
    debugPrint("Updating transaction...");
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      return _transactionService.updateTransaction(
          value.accessToken, updatedTransaction);
    });
  }

  Future<TransactionResponse> _getTransactionResponse() async {
    debugPrint("Fetching transactions...");
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      return _transactionService.fetchTransactions(
          value.accessToken, _fromDate, _toDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Overview'),
      ),
      body: FutureBuilder<TransactionResponse>(
        future: _transactionResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return const LoadingSpinner();
          }

          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          var data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PeriodSelector(
                    fromDate: _fromDate,
                    toDate: _toDate,
                    initialDatePeriod: _datePeriod,
                    onPeriodChange: (x) {
                      debugPrint("From: ${x.from}");
                      debugPrint("To: ${x.to}");
                      setState(() {
                        _fromDate = x.from;
                        _toDate = x.to;
                        _transactionResponse = _getTransactionResponse();
                      });
                    }),
                Divider(),
                // Row( // TODO
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ElevatedButton.icon(
                //       label: Text("Sync"),
                //       onPressed: () async {
                //         await _syncTransactions();
                //         setState(() {
                //           _transactionResponse = _getTransactionResponse();
                //         });
                //       },
                //       icon: Icon(
                //         Icons.cloud_sync,
                //       ),
                //     ),
                //   ],
                // ),
                CategoryTotalList(
                  categoryTotals: data.categoryTotals,
                  onTapCallback: (categoryName) {
                    debugPrint("Tapped: $categoryName category");
                    var transactions = data.transactions
                        .where((x) => x.category == categoryName)
                        .toList();
                    _showTransactionListPage(
                        context, transactions, "${categoryName} Transactions");
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: () {
                        _showTransactionListPage(
                            context, data.transactions, "All Transactions");
                      },
                      child: Text('View All Transactions')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTransactionListPage(
      BuildContext context, List<Transaction> data, String category) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionListPage(
                  title: category,
                  transactionResponse: data,
                  onTransactionUpdated: (x) async {
                    await _updateTransaction(x);
                    var snackBar = SnackBar(
                        content: Text('Updated transaction successfully'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _transactionResponse = _getTransactionResponse();
                    });
                  },
                )));
  }
}
