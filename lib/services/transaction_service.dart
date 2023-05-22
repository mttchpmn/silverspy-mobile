import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:silverspy/models/transaction_response_model.dart';

import '../models/transaction_model.dart';

class TransactionService {
  final String apiUrl = 'https://staging.api.silverspy.io/transactions';
  final String akahuId = '';
  final String akahuToken = '';

  Future<void> syncTransactions(
      String accessToken, String akahuId, String akahuToken) async {
    debugPrint("Syncing transactions");
    var url = "$apiUrl/ingest";
    var headers = <String, String>{
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json; charset=UTF-8"
    };
    final response = await http.post(Uri.parse(url),
        headers: headers,
        body: json.encode({
          'akahuId': akahuId,
          'akahuToken': akahuToken,
        }));

    if (response.statusCode != 200) {
      throw Exception("Error syncing transactions: ${response.statusCode}");
    }
  }

  Future<Transaction> updateTransaction(
      String accessToken, Transaction updatedTransaction) async {
    var headers = <String, String>{
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json; charset=UTF-8"
    };

    debugPrint("Fetching transactions from $apiUrl");

    final response = await http.patch(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode({
          'transactionId': updatedTransaction.id,
          'category': updatedTransaction.category,
          'details': updatedTransaction.details
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      var transaction = Transaction.fromJson(data);

      return transaction;
    }
    throw Exception('Failed to update transaction');
  }

  Future<TransactionResponse> fetchTransactions(
      String accessToken, DateTime fromDate, DateTime toDate) async {
    var url =
        "$apiUrl?from=${fromDate.toLocal().toIso8601String()}&to=${toDate.toLocal().toIso8601String()}";

    var headers = <String, String>{"Authorization": "Bearer $accessToken"};
    debugPrint("Fetching transactions from ${fromDate.toIso8601String()} to ${toDate.toIso8601String()}");
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      var transactionResponse = TransactionResponse.fromJson(data);

      debugPrint(
          "Fetched ${transactionResponse.transactions.length.toString()} transactions");

      return transactionResponse;
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
