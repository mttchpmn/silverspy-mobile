import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';

class TransactionService {
  final String apiUrl = 'https://example.com/api/transactions';

  Future<List<Transaction>> getTransactions() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Transaction> transactions = [];

      for (var i = 0; i < data.length; i++) {
        transactions.add(Transaction.fromJson(data[i]));
      }

      return transactions;
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
