import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/components/alert_dialog.dart';
import 'package:silverspy/components/date_range_picker.dart';
import 'package:silverspy/components/full_width_button.dart';
import 'package:silverspy/components/period_selector.dart';
import 'package:silverspy/components/transaction_category_total_list.dart';
import 'package:silverspy/helpers/date_helper.dart';
import 'package:silverspy/models/transaction_response_model.dart';
import 'package:silverspy/providers/akahu_provider.dart';
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
  final AkahuProvider _akahuProvider = AkahuProvider();

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
    var credentials = await _akahuProvider.loadCredentials();

    if (credentials.akahuId == "" || credentials.accessToken == "") {
      _showAlertDialog();
    }

    return authProvider.getCredentials().then((value) {
      return _transactionService.syncTransactions(
          value.accessToken, credentials.akahuId, credentials.accessToken);
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

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Alert(
          label: "Missing Credentials",
          detail: "Please set your Akahu credentials in the settings page",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Overview'),
      ),
      body: Column(
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
          const Divider(),
          Expanded(
            child: FutureBuilder<TransactionResponse>(
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
                      CategoryTotalList(
                        categoryTotals: data.categoryTotals,
                        onTapCallback: (categoryName) {
                          _handleCategorySelect(data, categoryName, context);
                        },
                      ),
                      FullWidthButton(
                          label: 'View All Transactions',
                          onPressed: () {
                            _showTransactionListPage(
                                context, data.transactions, "All Transactions");
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.purple,
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () async {
                              await _syncTransactions();
                              var snackBar = const SnackBar(
                                  content: Text(
                                      'Synced transactions with bank successfully'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                _transactionResponse =
                                    _getTransactionResponse();
                              });
                            },
                            child: Text("Sync with Bank")),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleCategorySelect(
      TransactionResponse data, String categoryName, BuildContext context) {
    var transactions =
        data.transactions.where((x) => x.category == categoryName).toList();
    _showTransactionListPage(
        context, transactions, "${categoryName} Transactions");
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
                    var snackBar = const SnackBar(
                        content: Text('Updated transaction successfully'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _transactionResponse = _getTransactionResponse();
                    });
                  },
                )));
  }
}
