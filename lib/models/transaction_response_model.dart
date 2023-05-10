
import 'package:silverspy/constants/finance_category.dart';
import 'package:silverspy/models/transaction_model.dart';

class TransactionResponse{
  final List<Transaction> transactions;
  final List<TransactionCategorySummary> categoryTotals;

  TransactionResponse({required this.transactions, required this.categoryTotals});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    List<Transaction> transactions = json['transactions'].map<Transaction>((x) => Transaction.fromJson(x)).toList();
    List<TransactionCategorySummary> categoryTotals = json['categoryTotals'].map<TransactionCategorySummary>((x) => TransactionCategorySummary.fromJson(x)).toList();

    return TransactionResponse(
     transactions: transactions,
     categoryTotals: categoryTotals
    );
  }
}

class TransactionCategorySummary {
  final FinanceCategory category;
  final double currentSpend;
  final double budget; // Per week

  TransactionCategorySummary({required this.category, required this.currentSpend, required this.budget});

  factory TransactionCategorySummary.fromJson(Map<String, dynamic> json) {
    return TransactionCategorySummary(
      category: FinanceCategoryExtensions.parse(json['category']),
      currentSpend: double.parse(json['currentSpend'].toString()),
      budget: double.parse(json['budget'].toString()),
    );
  }
}