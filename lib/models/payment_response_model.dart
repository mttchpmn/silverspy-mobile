import 'package:flutter/foundation.dart';

import 'payment_model.dart';

class PaymentData {
  final List<Payment> payments;
  final PaymentTypeSummary monthlyIncoming;
  final PaymentTypeSummary monthlyOutgoing;
  final PaymentTypeSummary monthlyNet;
  final List<PaymentCategoryTotal> categoryTotals;

  PaymentData(
      {required this.payments,
      required this.monthlyIncoming,
      required this.monthlyOutgoing,
      required this.monthlyNet,
      required this.categoryTotals});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    List<Payment> payments =
        json['payments'].map<Payment>((x) => Payment.fromJson(x)).toList();

    var categoryTotals = json['categoryTotals'].map<PaymentCategoryTotal>((x) => PaymentCategoryTotal.fromJson(x)).toList();

    return PaymentData(
        payments: payments,
        monthlyIncoming: PaymentTypeSummary.fromJson(json['monthlyIncoming']),
        monthlyOutgoing: PaymentTypeSummary.fromJson(json['monthlyOutgoing']),
        monthlyNet: PaymentTypeSummary.fromJson(json['monthlyNet']),
        categoryTotals: categoryTotals
    );
  }
}

class PaymentTypeSummary {
  final int count;
  final double total;

  PaymentTypeSummary({required this.count, required this.total});

  factory PaymentTypeSummary.fromJson(Map<String, dynamic> json) {
    return PaymentTypeSummary(count: json['count'], total: json['total']);
  }
}

class PaymentCategoryTotal {
  final String category;
  final double total;

  PaymentCategoryTotal({required this.category, required this.total});

  factory PaymentCategoryTotal.fromJson(Map<String, dynamic> json) {
    return PaymentCategoryTotal(
        category: json['category'], total: json['total'] ?? 0);
  }
}
