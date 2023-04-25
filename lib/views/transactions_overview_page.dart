import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/components/date_range_picker.dart';
import 'package:silverspy/components/transaction_category_total_list.dart';
import 'package:silverspy/models/transaction_response_model.dart';
import 'package:silverspy/views/payments_list_page.dart';
import 'package:silverspy/views/transactions_list_page.dart';

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
  String _bankType = "ASB";
  String _period = "PAYPERIOD";

  DateTime _toDate = DateTime.now();
  DateTime _fromDate = DateTime.now();

  late File? _csvFile;
  late String _accessToken;

  late Future<TransactionResponse> _transactionResponse;

  @override
  void initState() {
    super.initState();

    _transactionResponse = _getTransactionResponse();
  }

  Future<TransactionResponse> _getTransactionResponse() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      _accessToken = value.accessToken;
      return _transactionService.fetchTransactions(value.accessToken);
    });
  }

  Future<void> _importTransactions() async {
    if (_csvFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a CSV file.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      String fileContent = await _csvFile!.readAsString();
      debugPrint(fileContent);
      // TransactionService.importTransactions(_bankType, fileContent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transactions imported successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error importing transactions. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectCsvFile() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      setState(() {
        _csvFile = File(result.files.single.path!); // TODO - Remove bang
      });
    }
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
          if (!snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  )
                ]);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      label: Text("Sync with bank"),
                      onPressed: () {
                        // TODO
                      },
                      icon: Icon(Icons.cloud_sync,),
                    ),
                  ],
                ),

                CategoryTotalList(categoryTotals: data.categoryTotals),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionListPage()));
                    },
                    child: Text('View All Transactions')),
              ],
            ),
          );

        },

      ),
    );
  }
}
