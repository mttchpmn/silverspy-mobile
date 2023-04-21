
import 'package:silverspy/models/transaction_model.dart';

class TransactionResponse{
  final List<Transaction> transactions;
  final List<TransactionCategoryTotal> categoryTotals;

  TransactionResponse({required this.transactions, required this.categoryTotals});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    List<Transaction> transactions = json['transactions'].map<Transaction>((x) => Transaction.fromJson(x)).toList();
    List<TransactionCategoryTotal> categoryTotals = json['categoryTotals'].map<TransactionCategoryTotal>((x) => TransactionCategoryTotal.fromJson(x)).toList();

    return TransactionResponse(
     transactions: transactions,
     categoryTotals: categoryTotals
    );
  }
}

class TransactionCategoryTotal {
  final String category;
  final double value;

  TransactionCategoryTotal({required this.category, required this.value});

  factory TransactionCategoryTotal.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryTotal(
      category: json['category'],
      value: double.parse(json['value'].toString()),
    );
  }
}