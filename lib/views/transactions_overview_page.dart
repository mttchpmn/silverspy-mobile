import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:silverspy/components/date_range_picker.dart';
import 'package:silverspy/views/payments_list_page.dart';
import 'package:silverspy/views/transactions_list_page.dart';

import '../services/transaction_service.dart';

class TransactionsOverviewPage extends StatefulWidget {
  const TransactionsOverviewPage({super.key});

  @override
  _TransactionsOverviewPageState createState() =>
      _TransactionsOverviewPageState();
}

class _TransactionsOverviewPageState extends State<TransactionsOverviewPage> {
  String _bankType = "ASB";
  String _period = "PAYPERIOD";

  DateTime _toDate = DateTime.now();
  DateTime _fromDate = DateTime.now();

  late File? _csvFile;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // DateRangePickerWidget(fromDateCallback: (from) => setState(() { _fromDate = from;}), toDateCallback: (from) => setState(() { _fromDate = from;}))
                // DropdownButton<String>(
                //   value: _period,
                //   onChanged: (value) {
                //     setState(() {
                //       _period = value ?? "";
                //     });
                //   },
                //   items: [
                //     DropdownMenuItem(
                //       value: 'PAYPERIOD',
                //       child: Text('This Pay Period'),
                //     ),
                //     DropdownMenuItem(
                //       value: 'WEEK',
                //       child: Text('This Week'),
                //     ),
                //     DropdownMenuItem(
                //       value: 'MONTH',
                //       child: Text('This Month'),
                //     ),
                //     DropdownMenuItem(
                //       value: 'YEAR',
                //       child: Text('This Year'),
                //     ),
                //   ],
                // ),
                // ElevatedButton.icon(
                //   label: Text("Import"),
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           title: Text('Import Transactions'),
                //           content: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text("Select your bank"),
                //                   DropdownButton<String>(
                //                     value: _bankType,
                //                     onChanged: (value) {
                //                       setState(() {
                //                         _bankType = value ?? "";
                //                       });
                //                     },
                //                     items: [
                //                       DropdownMenuItem(
                //                         value: 'ASB',
                //                         child: Text('ASB'),
                //                       ),
                //                       DropdownMenuItem(
                //                         value: 'BNZ',
                //                         child: Text('BNZ'),
                //                         enabled: false,
                //                       ),
                //                       DropdownMenuItem(
                //                         value: 'ANZ',
                //                         child: Text('ANZ'),
                //                         enabled: false,
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(height: 20),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text("CSV file"),
                //                   ElevatedButton.icon(
                //                     onPressed: _selectCsvFile,
                //                     icon: Icon(Icons.folder),
                //                     label: Text('Select'),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //           actions: [
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.pop(context);
                //               },
                //               child: Text('Cancel'),
                //             ),
                //             ElevatedButton(
                //               onPressed: _importTransactions,
                //               child: Text('Import'),
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                //   icon: Icon(Icons.file_upload,),
                // ),
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size.fromHeight(50)
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionListPage()));
                },
                child: Text('View All Transactions')),
          ],
        ),
      ),
    );
  }
}
