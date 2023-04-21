import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:silverspy/models/transaction_response_model.dart';

class TransactionService {
  final String apiUrl = 'https://staging.api.silverspy.io/transactions';

  Future<TransactionResponse> fetchTransactions(String accessToken) async {
    var headers = <String, String>{"Authorization": "Bearer $accessToken"};
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      var transactionResponse = TransactionResponse.fromJson(data);

      return transactionResponse;
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
